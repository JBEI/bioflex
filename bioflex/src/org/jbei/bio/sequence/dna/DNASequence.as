package org.jbei.bio.sequence.dna
{
    import org.jbei.bio.sequence.common.Sequence;
    import org.jbei.bio.sequence.common.SymbolList;

    /**
    * DNA sequence with extra meta information
    * 
    * @author Zinovii Dmytriv
    */
    public class DNASequence extends Sequence
    {
        private var _accession:String;
        private var _version:int;
        private var _seqVersion:Number;
        private var _circular:Boolean;
        
        // Constructor
        /**
        * Contructor
        * 
        * @param symbolList DNA sequence
        * @param name Sequence name
        * @param circular Defines if sequence is circular or not. Default <code>false</code>
        * @param accession Sequence accession number
        * @param version Version
        * @param seqVersion Sequence version
        */
        public function DNASequence(symbolList:SymbolList, name:String = "", circular:Boolean = false, accession:String = "", version:int = 1, seqVersion:Number = 0.0)
        {
            super(symbolList, name);
            
            _accession = accession;
            _version = version;
            _seqVersion = seqVersion;
            _circular = circular;
        }
        
        // Properties
        /**
        * Sequence accession number
        */
        public function get accession():String
        {
            return _accession;
        }
        
        public function set accession(value:String):void
        {
            _accession = value;
        }
        
        /**
         * Version
         */
        public function get version():int
        {
            return _version;
        }
        
        public function set version(value:int):void
        {
            _version = value;
        }
        
        /**
         * Sequence version
         */
        public function get seqVersion():Number
        {
            return _seqVersion;
        }
        
        public function set seqVersion(value:Number):void
        {
            _seqVersion = value;
        }
        
        /**
         * Is circular
         */
        public function get circular():Boolean
        {
            return _circular;
        }
        
        public function set circular(value:Boolean):void
        {
            _circular = value;
        }
    }
}