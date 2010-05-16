package org.jbei.bio.components.sequence.sequenceEditorClasses
{
    /**
     * @author Zinovii Dmytriv
     */
    public class RowMapper
    {
        private var contentHolder:ContentHolder;
        
        private var _rows:Array /* of Row */;
        private var numRows:int = 0;
        
        // Contructor
        public function RowMapper(contentHolder:ContentHolder)
        {
            this.contentHolder = contentHolder;
        }
        
        // Properties
        public final function get rows():Array /* of Row */
        {
            return _rows;
        }
        
        // Public Methods
        public function update():void
        {
            _rows = new Array();
            
            var bpPerRow:int = contentHolder.bpPerRow;
            
            var sequence:String = contentHolder.sequenceProvider.sequence.seqString().toUpperCase();
            var revComSequence:String = "";
            
            if(contentHolder.showRevComplement) {
                revComSequence = contentHolder.sequenceProvider.revComSequence.seqString().toUpperCase();
            }
            
            numRows = int(Math.ceil(((sequence.length + 1) / bpPerRow)));
            
            for(var i:int = 0; i < numRows; i++) {
                var start:int = i * bpPerRow;
                var end:int = (i + 1) * bpPerRow - 1;
                
                var rowSequence:String = sequence.substring(start, end + 1);
                var rowRevComSequence:String = "";
                
                if(contentHolder.showRevComplement) {
                    rowRevComSequence = revComSequence.substring(start, end + 1);
                }
                
                _rows.push(new Row(i, start, end, rowSequence, rowRevComSequence));
            }
        }
    }
}
