package org.jbei.bio.parsers
{
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
        public function parseGenbankFile(genbankFile:String):GenbankFileModel 
        {
            var genbank:GenbankFileModel = new GenbankFileModel();
            
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
                } else {
                    genbank.keywords.push(keyword);
                }
                
            }
            return genbank;
        }
        
        public function generateGenbankFile(genbankFileModel:GenbankFileModel):String
        {
            var result:String = "";
            genbankFileModel.locus.sequenceLength = genbankFileModel.origin.sequence.length.toString();
            result = result + generateLocusKeyword(genbankFileModel.locus);
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

            keyword = block.substr(0, 12);
            keyword = StringUtil.trim(keyword);
            
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
                result = parseOriginBlock(block);
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

        private static function parseFeatureKeywordBlock(block:String):GenbankFeatureElement
        {
            var result:GenbankFeatureElement = new GenbankFeatureElement();
            var qualifierBlocks:Vector.<String> = splitFeatureQualifierBlocks(block);
            result.key = StringUtil.trim(block.substring(5, 21));
            var location:String = StringUtil.trim(block.substr(21));
            if (location.charAt(0) == "c") { // complement
                location = location.substr(11);
                location = location.substr(0, location.length -1);
                result.strand = -1;
            } else {
                result.strand = 1;
            }
            var splitLocation:Array = location.split("..");
            result.genbankStart = parseInt(splitLocation[0]);
            result.end = parseInt(splitLocation[1]);
            
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
            qualifier.value = value;
            
            return qualifier;
        }
        
        private static function parseLocusBlock(block:String):GenbankLocusKeyword
        {
            var result:GenbankLocusKeyword = new GenbankLocusKeyword();
            
            var temp:Array = block.split(" ");
            // flex's silly split
            var fields:Array = new Array();
            
            for (var i:int = 0; i < temp.length; i++) {
                if (temp[i] != "") {
                    fields.push(temp[i]);
                }
            }
            
            result.locusName = fields[1] as String;
            result.strandType = (fields[4] as String).substring(0, 2);
            result.naType = (fields[4] as String).substr(3);
            
            var linear:String = (fields[5] as String);
            if (linear == "circular") {
                result.linear = false;
            } else {
                result.linear = true; //blank implies linear
            }
            
            var divCode:String = (fields[fields.length - 2] as String);
            if (divCode.length == 3) {
                result.divisionCode = divCode;
            }
            
            var strDate:String = (fields[fields.length - 1] as String);
            
            var year:int = parseInt(strDate.substring(7, 11)); 
            var day:int = parseInt(strDate.substring(0, 2)); 
            var strMonth:String = strDate.substring(3, 6);
            var month:int = 1;
            
            switch (strMonth)
            {
                case "JAN":
                    month = 0;
                    break;
                case "FEB":
                    month = 1;
                    break;
                case "MAR":
                    month = 2;
                    break;
                case "APR":
                    month = 3;
                    break;
                case "MAY":
                    month = 4;
                    break;
                case "JUN":
                    month = 5;
                    break;
                case "JUL":
                    month = 6;
                    break;
                case "AUG":
                    month = 7;
                    break;
                case "SEP":
                    month = 8;
                    break;
                case "OCT":
                    month = 9;
                    break;
                case "NOV":
                    month = 10;
                    break;
                case "DEC":
                    month = 11;
                    break;
                    
            }

            var tempDate:Date = new Date();
            tempDate.setUTCDate(day);
            tempDate.setUTCFullYear(year);
            tempDate.setUTCMonth(month);
            tempDate.setUTCHours(0);
            tempDate.setUTCMinutes(0);
            tempDate.setUTCMilliseconds(0);
            

            result.date = tempDate;  
            
            return result;
        }

        private static function parseOriginBlock(block:String):GenbankKeyword
        {
            var result:GenbankOriginKeyword = new GenbankOriginKeyword();
            
            var lines:Array = block.split("\n");
            
            result.keyword = StringUtil.trim((lines[0] as String).substr(0, 12));
            result.value = StringUtil.trim((lines[0] as String).substring(12));
            
            var line:String = "";
            var seqBlocks:Array = null;
            for(var i:int = 1; i < lines.length; i++) {
                seqBlocks = (lines[i] as String).substr(10).split(" ");
                
                line = line + seqBlocks.join(""); 
            }
            
            result.sequence = line.toLowerCase();
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
            result = result + paddedString(locusKeyword.divisionCode, 3);
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
            result = result + originKeyword.value + "\n";
            
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
                    if (tempFeature.strand == 1) {
                        result = result + tempFeature.genbankStart.toString() + ".." + tempFeature.end.toString() + "\n";
                    } else {
                        result = result + "complement(" + tempFeature.genbankStart.toString() + ".." + tempFeature.end.toString() + ")\n";
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