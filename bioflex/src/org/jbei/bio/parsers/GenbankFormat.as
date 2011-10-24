package org.jbei.bio.parsers
{
    import mx.collections.ArrayCollection;
    import mx.utils.StringUtil;
    
    import org.jbei.bio.sequence.alphabets.AbstractAlphabet;

    /**
    * @author Timothy Ham
    * 
    * The Official Genbank format is defined in 
    * ftp://ftp.ncbi.nlm.nih.gov/genbank/gbrel.txt
    * 
    * However, they only define the current format. There are
    * apparently older formats (especially LOCUS) that are still
    * around (and are in fact still presented as examples within
    * gbrel.txt), as well as various software that implement some
    * subsets of the spec in different ways. 
    * 
    */
    public class GenbankFormat
    {
    
        public static const LOCUS_TAG:String = "LOCUS";
        public static const DEFINITION_TAG:String = "DEFINITION";
        public static const ACCESSION_TAG:String = "ACCESSION";
        public static const VERSION_TAG:String = "VERSION";
        public static const KEYWORDS_TAG:String = "KEYWORDS";
        //                                                  "SEGMENT"
        public static const SOURCE_TAG:String = "SOURCE";
        public static const ORGANISM_TAG:String = "ORGANISM";
        public static const REFERENCE_TAG:String = "REFERENCE";
        public static const AUTHORS_TAG:String = "AUTHORS";
        public static const CONSORTIUM_TAG:String = "CONSRTM";
        public static const TITLE_TAG:String = "TITLE";
        public static const JOURNAL_TAG:String = "JOURNAL";
        public static const PUBMED_TAG:String = "PUBMED";
        public static const REMARK_TAG:String = "REMARK";
        public static const COMMENT_TAG:String = "COMMENT";
        public static const FEATURE_TAG:String = "FEATURES";
        public static const BASE_COUNT_TAG:String = "BASE COUNT";
        //                                                  "CONTIG"
        public static const ORIGIN_TAG:String = "ORIGIN";
        public static const END_SEQUENCE_TAG:String = "//";
    
        public function GenbankFormat()
        {
        }
             
        /**
        * 
        * Parsing is performed by first breaking up the document into 
        * keyword blocks, subkeyword blocks, then parsing them. 
        * 
        * In general, keyword blocks are the same format, except
        * LOCUS, FEATURES, and ORIGIN blocks. They have special
        * rules for line wrapping and etc that need their own handlers.
        * 
        * Populates the GenbankModel when done.
        *  
        */
        public static function parseGenbankFile(genbankFile:String):GenbankFileModel 
        {
            var genbank:GenbankFileModel = new GenbankFileModel();
            var tempArray:Array = extractOrigin(genbankFile);
            genbank.origin = tempArray[0] as GenbankOriginKeyword;
            genbankFile = tempArray[1] as String;
            
            var keywordBlocks:Vector.<String> = splitKeywordBlocks(genbankFile);            
            
            var keyword:GenbankKeyword;
            
            for (var i:int = 0; i < keywordBlocks.length; i++) {
                keyword = parseKeywordBlock(keywordBlocks[i]);
                if (keyword.keyword == FEATURE_TAG) {
                    genbank.features = keyword as GenbankFeatureKeyword;
                } else if (keyword.keyword == ORIGIN_TAG) {
                    genbank.origin = keyword as GenbankOriginKeyword;
                } else if (keyword.keyword == LOCUS_TAG) {
                    genbank.locus = keyword as GenbankLocusKeyword;
                }  else if (keyword.keyword == ACCESSION_TAG) {
                    genbank.accession = keyword.value;
                } else if (keyword.keyword == VERSION_TAG) {
                    genbank.version = keyword.value;
                } else {
                    genbank.keywords.push(keyword);
                }
                
            }
            return genbank;
        }
        
        public static function generateGenbankFile(genbankFileModel:GenbankFileModel):String
        {
            var result:String = "";
            genbankFileModel.locus.sequenceLength = genbankFileModel.origin.sequence.length.toString();
            result = result + generateLocusKeyword(genbankFileModel.locus);
            result = result + paddedString("ACCESSION", 12) + genbankFileModel.accession + "\n";
            result = result + paddedString("VERSION", 12) + genbankFileModel.version + "\n";
            result = result + paddedString("KEYWORDS", 12) + genbankFileModel.keywordsTag + "\n";
            for (var i:int = 0; i < genbankFileModel.keywords.length; i++) {
                result = result + generateKeyword(genbankFileModel.keywords[i]);
            }
            result = result + generateFeatureKeyword(genbankFileModel.features);
            result = result + generateOriginKeyword(genbankFileModel.origin);
            result = result + "//\n";
            
            return result;
        }
        
        private static function parseKeywordBlock(block:String):GenbankKeyword
        {
            if (block == "") {
                return null;
            }
            var result:GenbankKeyword = new GenbankKeyword();
            var keyword:String = "";
            var body:String = "";
            var subKeywords:Vector.<GenbankSubKeyword> = new Vector.<GenbankSubKeyword>();
            
            var subBlocks:Vector.<String> = null;

			var re:RegExp = / +/;
			var chunks:Array = block.split(re);
			
            keyword = StringUtil.trim(chunks[0]);
            
            if (keyword == LOCUS_TAG) {
                var locusResult:GenbankLocusKeyword = parseLocusBlock(block);
                result = locusResult;
            } else if (keyword == FEATURE_TAG) {
                subBlocks = splitFeatureKeywordBlocks(block);
                var features:Vector.<GenbankFeatureElement> = new Vector.<GenbankFeatureElement>();
                for (i = 1; i< subBlocks.length; i++) {
                    features.push(parseFeatureKeywordBlock(subBlocks[i]));
                }
                var subResult:GenbankFeatureKeyword = new GenbankFeatureKeyword();
                subResult.keyword = keyword;
                subResult.features = features;
                result = subResult;
                
            } else if (keyword == ORIGIN_TAG) {
                // origin tag is parsed elsewhere
            } else if (keyword == END_SEQUENCE_TAG) {
                
            } else {

                // parse multiline normal keyword block
                subBlocks = splitSubKeywordBlocks(block);
                var keywordLines:Array = subBlocks[0].split("\n");
                var i:int = 0;
                for (i = 0; i < keywordLines.length; i++) {
                    body = body + " " + StringUtil.trim((keywordLines[i] as String).substr(12));
                }
                body = StringUtil.trim(body);
                
                result.value = body;
                
                // parse sub blocks
                var subKeyword:String = "";
                var subBody:String = "";
                for (i = 1; i < subBlocks.length; i++) {
                    subKeywords.push(parseSubKeywordBlock(subBlocks[i]));
                }
            }
            
            result.keyword = keyword;
            result.subKeywords =subKeywords;
            
            return result;
        }
        
        private static function extractOrigin(genbankFile:String):Array
        {
            var result:Array = new Array();
            var genbankOriginKeyword:GenbankOriginKeyword = new GenbankOriginKeyword();
            var sequence:String = "";
            var rest:String = "";
            
            var lines:Array = genbankFile.split("\n");
            var line:String;
            var inSequenceBlock:Boolean = false;
            var sequenceBlock:String = "";
            
            
            
            
            for (var i:int = 0; i < lines.length; i++) {
                line = lines[i] as String;
                if ("ORIGIN" == line.substr(0, 6)) {
                    genbankOriginKeyword.keyword = StringUtil.trim(line.substr(0, 12));
                    genbankOriginKeyword.value = StringUtil.trim(line.substring(12));
                    inSequenceBlock = true;
                    i++; // skip to next line
                    line = lines[i] as String;
                }
                if ("//" == line.substr(0, 2)) {
                    inSequenceBlock = false;
                }
                if (inSequenceBlock) {
                    var segments:Array = StringUtil.trim(line).split(" ");
                    if (segments.length == 1) {
                        // no spaces. Probably fasta
                        sequence = sequence + (segments[0] as String).toLocaleLowerCase();
                    } else {
                        // probably numbered lines with spaces
                        sequence = sequence + segments.slice(1).join("");
                    }
                    
                } else {
                    rest = rest + line + "\n";
                }
            }
            
            genbankOriginKeyword.sequence = sequence;
            result.push(genbankOriginKeyword);
            result.push(rest);
            
            return result;
        }
        
        private static function splitKeywordBlocks(genbankFile:String):Vector.<String>
        {
            return splitBlocksByCharAt(genbankFile, 0);
        }
        
        private static function splitSubKeywordBlocks(block:String):Vector.<String>
        {
            return splitBlocksByCharAt(block, 2);
        }

        private static function parseSubKeywordBlock(block:String):GenbankSubKeyword
        {
            var result:GenbankSubKeyword = new GenbankSubKeyword ();
            
            var lines:Array = block.split("\n");
            var keyword:String = (lines[0] as String).substr(0, 12);
            keyword = StringUtil.trim(keyword);
            var value:String = (lines[0] as String).substr(12);
            var lineCount:int = 1;
            for (lineCount = 1; lineCount < lines.length; lineCount++) {
                value = value + " " + StringUtil.trim(lines[lineCount] as String);
            } 
            
            result.key = keyword;
            result.value = value;

            return result;
        }
        
        private static function splitFeatureKeywordBlocks(block:String):Vector.<String>
        {
            return splitBlocksByCharAt(block, 5);
        }

		/**
		 * Parses a genbank style multiple location string.
		 * 
		 * @return Returns a Vector. Array of [genbankStart, end], in order of appearance.
		 * 
		 * @author Timothy Ham
		 */
		
		public static function parseGenbankLocation(text:String):Vector.<Array>
		{
			text = StringUtil.trim(text);
			var reverseLocations:Boolean = false;
			if ("complement(join" == text.substr(0, 15)) { // this is a properly formatted complement of joins
				reverseLocations = true;
			}
			if ("join" == text.substr(0, 4)) {
				text = StringUtil.trim(text.substr(5, text.length - 2));
			}
			var result:Vector.<Array> = new Vector.<Array>;
			var startStopPattern:RegExp = new RegExp("[<>]*(\\d+)\\.\\.[<>]*(\\d+)", "");
			var startOnlyPattern:RegExp = new RegExp("\\d+", "");
			var genbankStart:int = -1;
			var end:int = -1;
			
			var chunks:Array = text.split(",");
			
			for (var i:int = 0; i < chunks.length; i++) {
				var chunk:String = chunks[i] as String;
				chunk = StringUtil.trim(chunk);
				var startStopMatches:Object = startStopPattern.exec(chunk);
				
				if (startStopMatches != null) {
						genbankStart = parseInt(startStopMatches[1]);
						end = parseInt(startStopMatches[2]);
						result.push(new Array(genbankStart, end));
				} else {
					var startOnlyMatches:Object = startOnlyPattern.exec(chunk);
					if (startOnlyMatches != null) {
						genbankStart = parseInt(startOnlyMatches[0]);
						end = genbankStart;
						result.push(new Array(genbankStart, end));
					}
				}
			}
			if (reverseLocations) {
				result = result.reverse();
			}
			return result;
		}
		
        private static function parseFeatureKeywordBlock(block:String):GenbankFeatureElement
        {
            var result:GenbankFeatureElement = new GenbankFeatureElement();
            var qualifierBlocks:Vector.<String> = splitFeatureQualifierBlocks(block);
            result.key = StringUtil.trim(block.substring(5, 21));
            var location:String = StringUtil.trim(block.substr(21));
            if (location.charAt(0) == "c") { // complement
                location = location.substr(11);
                location = location.substr(0, location.length -1);
				location = StringUtil.trim(location);
                result.strand = -1;
            } else {
                result.strand = 1;
            }
			var tempLocations:Vector.<Array> = parseGenbankLocation(location);
			
			result.featureLocations = new Vector.<GenbankLocation>();
			for (var j:int = 0; j < tempLocations.length; j++) {
				result.featureLocations.push(new GenbankLocation(tempLocations[j][0], tempLocations[j][1]));
			}
			
            var qualifiers:Vector.<GenbankFeatureQualifier> = new Vector.<GenbankFeatureQualifier>();
            var i:int = 0;
            for (i = 0; i < qualifierBlocks.length; i++) {
                var qualifier:GenbankFeatureQualifier = parseFeatureQualifierBlock(qualifierBlocks[i]);
                if (qualifier != null) {
                    qualifiers.push(qualifier);
                }
            }
            result.featureQualifiers = qualifiers;
            return result;
        }
        
        private static function splitFeatureQualifierBlocks(block:String):Vector.<String>
        {
            var result:Vector.<String> = new Vector.<String>();
            if (block == "") {
                return null;
            }
            
            var lines:Array = block.split("\n");
            var i:int = 0;
            var newBlock:String = "";
            for (i = 1; i < lines.length; i++) { // discard first line
                var line:String = lines[i] as String;
                if (line.charAt(21) == "/") {
                    if (newBlock != "") {
                        result.push(newBlock);
                    }
                    newBlock = line;
                } else if (line != "") {
                    newBlock = newBlock + "\n" + line;
                }
            }
            
            result.push(newBlock);
            return result;
        }
        
        private static function parseFeatureQualifierBlock(block:String):GenbankFeatureQualifier
        {
            var qualifier:GenbankFeatureQualifier = new GenbankFeatureQualifier();
            
            if (block == "") {
                return null;
            }
            
            var lines:Array = block.split("\n");
            var i:int = 0;
            var newBlock:String = "";
            var line:String;
            var value:String;
            
            line = lines[0] as String;
            var splitLine:Array = line.split("=");
            qualifier.name = StringUtil.trim((splitLine[0] as String)).substr(1);
            value = StringUtil.trim(splitLine[1] as String);
            
            if (value.charAt(0) == "\"") {
                qualifier.quoted = true;
                value = value.substr(1);
            } else {
                qualifier.quoted = false;
            }
            
            var joiningCharacter:String = " ";
            
            if (qualifier.name == "translation") {
                joiningCharacter = "";    
            }
            
            for (i = 1; i < lines.length; i++) {
                line = StringUtil.trim(lines[i] as String);
                value = value + joiningCharacter + line;
            }
            
            if (value.charAt(value.length - 1) == "\"" && qualifier.quoted == true) {
                value = value.substr(0, value.length -1);
            }
            
            if (qualifier.name == "label") {
                value = value.replace(new RegExp("\\\\", "g"), " ");
            }
            qualifier.value = value;
            
            return qualifier;
        }
        
        private static function parseLocusBlock(block:String):GenbankLocusKeyword
        {
            var result:GenbankLocusKeyword = new GenbankLocusKeyword();
            
			var re:RegExp = / +/;
            var temp:Array = StringUtil.trim(block).split(re);
            
			if (temp.indexOf("bp") == 3) {
				result.locusName = temp[1] as String;
			} else {
				result.locusName = temp[1] as String;
			}
            
            result.strandType = "ds";
            result.naType = "DNA";
            
            if (block.search("linear") != -1) {
                result.linear = true;
            } else if (block.search("LINEAR") != -1) {
				result.linear = true;
			} else {
                result.linear = false;
            }

            result.date = new Date();  
            
            return result;
        }

        private static function splitBlocksByCharAt(block:String, index:int):Vector.<String>
        {
            var result:Vector.<String> = new Vector.<String>();
            if (block == "") {
                return null;
            }
            
            var lines:Array = block.split("\n");
            
            var newBlock:String = "";
            for (var i:int = 0; i < lines.length; i++) {
                var line:String = lines[i] as String;
                if (line.charAt(index) == " ") {
                    newBlock = newBlock + "\n" + line;
                } else if (line != "") {
                    if (newBlock != "") {
                        result.push(newBlock);
                    }
                    newBlock = line;
                }
            }
            result.push(newBlock);
            return result;
        }
        
        private static function generateLocusKeyword(locusKeyword:GenbankLocusKeyword):String
        {
            var result:String = paddedString("LOCUS", 12);
            
            result = result + paddedString(locusKeyword.locusName, 16);
            result = result + " "; // col 29 space
            result = result + paddedString(locusKeyword.sequenceLength, 11, true);
            result = result + " bp "; // col 41 space
            result = result + paddedString(locusKeyword.strandType + "-", 3);
            result = result + paddedString(locusKeyword.naType, 6);
            result = result + "  "; // col 54 space
            if (locusKeyword.linear == true) {
                result = result + "linear  ";
            } else {
                result = result + "circular";
            }
            result = result + " "; // col 64 space
            if (locusKeyword.divisionCode != null) {
                result = result + paddedString(locusKeyword.divisionCode, 3);
            } else {
                result = result + paddedString("", 3);
            }
            result = result + " "; // col 68 space
            
            var monthString:String = null;
            
            switch (locusKeyword.date.month) 
            {
                case 0:
                    monthString = "JAN";
                    break;
                case 1:
                    monthString = "FEB";
                    break;
                case 2:
                    monthString = "MAR";
                    break;
                case 3:
                    monthString = "APR";
                    break;
                case 4:
                    monthString = "MAY";
                    break;
                case 5:
                    monthString = "JUN";
                    break;
                case 6:
                    monthString = "JUL";
                    break;
                case 7:
                    monthString = "AUG";
                    break;
                case 8:
                    monthString = "SEP";
                    break;
                case 9:
                    monthString = "OCT";
                    break;
                case 10:
                    monthString = "NOV";
                    break;
                case 11:
                    monthString = "DEC";
                    break;
            }
            
             var dateString:String = locusKeyword.date.dateUTC + "-" + monthString+ "-" + locusKeyword.date.fullYearUTC;
            
             result = result + dateString + "\n";
            
            return result;
        }
        
        private static function generateOriginKeyword(originKeyword:GenbankOriginKeyword):String
        {
            var result:String = paddedString(ORIGIN_TAG, 12);
            if (originKeyword.value != null) {
                result = result + originKeyword.value + "\n";
            } else {
                result = result + "\n";
            }
            
            // sequence block
            var line:String = "";
            var rawLine:String = null;
            for (var offset:int = 0; offset < originKeyword.sequence.length; offset = offset + 60) {
                line = paddedString((offset + 1).toString(), 9, true);
                rawLine = originKeyword.sequence.substr(offset, 60);
                
                for (var wordOffset:int = 0; wordOffset < 60; wordOffset = wordOffset + 10) {
                    line = line + " " + rawLine.substr(wordOffset, 10)    
                }
                result = result + line + "\n";
            }
            
            return result;
        }
        
        private static function generateKeyword(keyword:GenbankKeyword):String
        {
            if (keyword.keyword == END_SEQUENCE_TAG) {
                return "";
            } else if (keyword.keyword == BASE_COUNT_TAG) {
                return "";
            }
            var result:String = paddedString(keyword.keyword, 12);
            var subKeyword:GenbankSubKeyword = null;
            if (keyword.value != null) {
                result = result + wrapLines(keyword.value, 12);
            }
            if (keyword.subKeywords.length > 0) {
                for (var i:int = 0; i < keyword.subKeywords.length; i++) {
                    subKeyword = keyword.subKeywords[i];
                    result = result + "  " + paddedString(subKeyword.key, 10);
                    result = result + wrapLines(subKeyword.value, 12);
                }
                
            }
                
            
            return result;
        }
        
        private static function generateFeatureKeyword(featureKeyword:GenbankFeatureKeyword):String
        {
            var result:String = "FEATURES             Location/Qualifiers\n";
            var subFeatures:GenbankFeatureElement = null;

            if (featureKeyword.features.length > 0) {
                var tempFeature:GenbankFeatureElement = null;
                for (var i:int = 0; i < featureKeyword.features.length; i++) {
                    tempFeature = featureKeyword.features[i];
                    result = result + "     " + paddedString(tempFeature.key, 16);
					
					var locationString:String = "";
					if (tempFeature.featureLocations.length == 1) {
						if (tempFeature.featureLocations[0].genbankStart == tempFeature.featureLocations[0].end) {
							locationString = tempFeature.featureLocations[0].genbankStart.toString();
						} else {
							locationString = tempFeature.featureLocations[0].genbankStart + ".." + tempFeature.featureLocations[0].end;
						}
					} else {
						locationString = "join(";
						if (tempFeature.strand == -1) {
							tempFeature.featureLocations = tempFeature.featureLocations.reverse();
						}
						for (var n:int = 0; n < tempFeature.featureLocations.length; n++) {
							if (tempFeature.featureLocations[n].genbankStart == tempFeature.featureLocations[n].end) {
								locationString = locationString + tempFeature.featureLocations[n].genbankStart;
							} else {
								locationString = locationString + tempFeature.featureLocations[n].genbankStart + 
									".." + tempFeature.featureLocations[n].end;
							}
							if (n != tempFeature.featureLocations.length - 1) {
								locationString = locationString + ",";
							}
						}
						
						locationString = locationString + ")";
					}
					
                    if (tempFeature.strand == 1) {
                        result = result + locationString + "\n";
                    } else {
                        result = result + "complement(" + locationString + ")\n";
                    }
                    if (tempFeature.featureQualifiers.length > 0) {
                        result = result + generateFeatureQualifiers(tempFeature.featureQualifiers);
                    }
                }
            }
            return result;
        }
        
        private static function generateFeatureQualifiers(qualifiers:Vector.<GenbankFeatureQualifier>):String
        {
            var result:String = "";
            var tempString:String = null;
            var tempValue:String = null;
            var qualifier:GenbankFeatureQualifier = null;
            for (var i:int = 0; i < qualifiers.length; i++) {
                qualifier = qualifiers[i];
                tempString = "/" + qualifier.name + "=";
                if (qualifier.quoted == true) {
                    tempValue = "\"" + qualifier.value + "\"";
                } else {
                    tempValue = qualifier.value;
                }
                tempString = tempString + tempValue;
                result = result + "                     " + wrapLines(tempString, 21);
                
            }
            
            return result;
        }
        private static function paddedString(value:String, length:int, leftPadding:Boolean = false):String
        {
            var result:String = "";
            var padding:String = "";
            
            if (value.length > length) {
                value = value.substr(0, length);
            } else {
                for (var i:int = 0; i < (length - value.length); i++) {
                    padding = padding + " ";
                }
            }
            if (leftPadding) {
                result = padding + value;
            } else {
                result = value + padding;    
            }
            
            return result;
        }
        
        private static function wrapLines(input:String, leftStartColumn:int = 12):String
        {
            // no padding on the first line, as the keyword is present there.
            var TEXT_WIDTH:int = 80 - leftStartColumn - 1;
            var LEFT_PADDING:String = "";
            for (var i:int = 0; i < leftStartColumn; i++) {
                LEFT_PADDING = LEFT_PADDING + " ";
            }
            
            var result:String = "";
            var tempLine:String = null;
            var stagedLine:String = null;
            
            var offset:int = 0;
            var lastSpace:int = 0;
            while(true) {
                tempLine = input.substr(offset, TEXT_WIDTH);
                if (tempLine.length < TEXT_WIDTH) {
                    stagedLine = tempLine;
                    offset = offset + tempLine.length;
                } else {
                    lastSpace = tempLine.lastIndexOf(" ");
                    if (lastSpace == -1) {
                        // no space in this line. Just break it at TEXT_WIDTH
                        stagedLine =  tempLine;
                        offset = offset + TEXT_WIDTH;
                    } else {
                        stagedLine = tempLine.substr(0, lastSpace);
                        offset = offset + lastSpace + 1;
                    }
                }
                result = result + LEFT_PADDING + stagedLine + "\n";
                
                if (offset >= input.length) {
                    break;
                }
            
            }
            result = result.substr(leftStartColumn); // remove spacing of the first line
        
            return result;
        }
        
    }
}