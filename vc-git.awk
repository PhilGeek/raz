BEGIN {
		
### Process output of "git status".
		if (script=="status") {
				modified = 0
		}

}



### Process output of "git log".
script=="log" && /^Hash:/ { Hash = substr($0, 2+match($0, ":")) }
script=="log" && /^Abr. Hash:/ { AbrHash = substr($0, 2+match($0, ":")) }
script=="log" && /^Parent Hashes:/ { ParentHashes = substr($0, 2+match($0, ":")) }
script=="log" && /^Abr. Parent Hashes:/ { AbrParentHashes = substr($0, 2+match($0, ":")) }
script=="log" && /^Author Name:/ { AuthorName = substr($0, 2+match($0, ":")) }
script=="log" && /^Author Email:/ { AuthorEmail = substr($0, 2+match($0, ":")) }
script=="log" && /^Author Date:/ { AuthorDate = substr($0, 2+match($0, ":")) }
script=="log" && /^Committer Name:/ { CommitterName = substr($0, 2+match($0, ":")) }
script=="log" && /^Committer Email:/ { CommitterEmail = substr($0, 2+match($0, ":")) }
script=="log" && /^Committer Date:/ { CommitterDate = substr($0, 2+match($0, ":")) }

### Process output of "git status".
### Changed index?
script=="status" && /^# Changes to be committed:/ { modified = 1 }
### Unstaged modifications?
script=="status" && /^# Changed but not updated:/ { modified = 2 }



END {
		
### Process output of "git log".
		if (script=="log") {
### Standard encoding is UTF-8.
				if (Encoding == "") Encoding = "UTF-8"
### Extract relevant information from variables.
				LongDate = substr(AuthorDate, 1, 25)
        DateRAW = substr(LongDate, 1, 10)
        DateISO = DateRAW
        DateTEX = DateISO
        gsub("-", "/", DateTEX)
				Time = substr(LongDate, 12, 14)
### Write Git specific macros.
				print "%%% Define Git specific macros."
				print "\\gdef\\GITHash{" Hash "}%"
				print "\\gdef\\GITAbrHash{" AbrHash "}%"
				print "\\gdef\\GITParentHashes{" ParentHashes "}%"
				print "\\gdef\\GITAbrParentHashes{" AbrParentHashes "}%"
				print "\\gdef\\GITAuthorName{" AuthorName "}%"
				print "\\gdef\\GITAuthorEmail{" AuthorEmail "}%"
				print "\\gdef\\GITAuthorDate{" AuthorDate "}%"
				print "\\gdef\\GITCommitterName{" CommitterName "}%"
				print "\\gdef\\GITCommitterEmail{" CommitterEmail "}%"
				print "\\gdef\\GITCommitterDate{" CommitterDate "}%"
### Write generic version control macros.
				print "%%% Define generic version control macros."
				print "\\gdef\\VCRevision{\\GITAbrHash}%"
				print "\\ifnum\\VCModified=0\\gdef\\VCRevisionMod{\\VCRevision}%"
				print "\\else\\gdef\\VCRevisionMod{\\VCRevision~\\VCModifiedText}%"
				print "\\fi%"
				print "\\gdef\\VCAuthor{\\GITAuthorName}%"
        print "\\gdef\\VCDateRAW{" DateRAW "}%"
        print "\\gdef\\VCDateISO{" DateISO "}%"
        print "\\gdef\\VCDateTEX{" DateTEX "}%"
				print "\\gdef\\VCTime{" Time "}%"
		}
		
### Process output of "git status".
		if (script=="status") {
				print "%%% Is working copy modified?"
				print "\\gdef\\VCModified{" modified "}%"
				print "\\gdef\\VCModifiedText{\\textcolor{red}{with local modifications!}}%"
		}
		
}
