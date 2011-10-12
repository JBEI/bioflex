package org.jbei.bio.sequence.common
{
	import flash.net.LocalConnection;
	
	import org.jbei.bio.BioException;

    [RemoteClass(alias="org.jbei.bio.sequence.common.Annotation")]
    /**
    * General annotation class.
	 * Now with multiple Locations. So it now manages locations on its own.
    * 
    * @author Zinovii Dmytriv
	* @author Timothy Ham
    */
    public class Annotation implements IAnnotation
    {
        private var _start:int = 0;
        private var _end:int = 0;
		
		// Location order is defined by the user, as there is no way to determine 
		// order in an annotation spanning 0 on a circular DNA. 
		private var _locations:Vector.<Location> = new Vector.<Location>();
		
        // Constructor
        /**
        * Contructor
        */
        public function Annotation(start:int = 0, end:int = 0)
        {
			locations.push(new Location(start, end));
        }
        
        // Properties
        /**
        * @inheritDoc
        */
        public function get start():int
        {
			if (locations.length > 0) {
				return locations[0].start;
			} else {
				return -1;
			}
        }
		
		/**
		 * Sets start when there is only one location.
		 */
		public function setOneStart(start:int):void
		{
			if (locations.length == 1) {
				locations[0].start = start;
			} else {
				throw new BioException("Cannot set start when multiple Locations exist");
			}
		}
        /*
        public function set start(value:int):void
        {
            // TODO
        }
        */
        /**
         * @inheritDoc
         */
        public function get end():int
        {
			if (locations.length > 0) {
				return locations[locations.length -1].end;
			} else {
				return 1;
			}
        }
		
		public function setOneEnd(end:int):void
		{
			if (locations.length == 1) {
				locations[0].end = end;
			} else {
				throw new BioException("Connot set end when multiple Locations eist");
			}
		}
        /*
        public function set end(value:int):void
        {
            //TODO
        }
		*/
		public function get locations():Vector.<Location>
		{
			return _locations;
		}
		
		public function set locations(locations:Vector.<Location>):void
		{
			_locations = locations;
		}
	
        // Public Methods
        /**
        * Calculates if this annotation contains another annotation.
        * 
        * @param annotation Annotation to check against
        */
        public function contains(annotation:Annotation):Boolean
        {
            var result:Boolean = false;
            
            if(_start <= _end) { // annotation1 non-circular
                if(annotation.start <= annotation.end) { // annotation2 non-circular 
                    result = ((_start <= annotation.start) && (_end >= annotation.end)); 
                }
            } else { // annotation1 circular
                if(annotation.start <= annotation.end) { // annotation2 non-circular
                    result = ((annotation.end <= _end) || (annotation.start >= _start));
                } else { // annotation1 circular
                    result = ((_start <= annotation.start) && (_end >= annotation.end));
                }
            }
            
            return result;
        }
		
		public function isMultiLocation():Boolean
		{
			if (locations.length >= 2) {
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Shifts all locations by shiftBy amount in place. Positive is to the "right", or increasing location index, and negative is to the left.
		 *  
		 * @author Timothy Ham
		 */
		public function shift(shiftBy:int, maxLength:int, circular:Boolean):Annotation
		{
			if (shiftBy > maxLength - 1) {
				throw new BioException("Cannot shift by greater than maximum length");
			}
			var offset:int = this.start;
			var tempLocations:Vector.<Location> = getNormalizedLocations(maxLength);
			var tempLocation:Location;
			for (var i:int = 0; i < tempLocations.length; i++) {
				tempLocation = tempLocations[i];
				tempLocation.start = tempLocation.start + shiftBy;
				tempLocation.end = tempLocation.end + shiftBy;
			}
			
			tempLocations = deNormalizeLocations(tempLocations, offset, maxLength, circular);
			locations = tempLocations;
			
			return this;
		}
		
		/**
		 * Insert basepairs, and update locations accordingly. Alter only the affected location.
		 * 
		 * @author Timothy Ham
		 */
		public function insertAt(position:int, insertLength:int, maxLength:int, circular:Boolean):Annotation
		{
			var shifting:Boolean = false;
			var tempEnd:int;
			var offset:int = locations[0].start;
			if (position < offset) { // insertion happens before the feature. Simply shift
				shifting = true;
			}
			var normalizedPosition:int = position - offset;
			
			var tempLocations:Vector.<Location> = getNormalizedLocations(maxLength);
			var currentLocation:Location;
			
			/* For each feature, if insertion position is before the feature, shift the current 
			feature and all the features after that. If the position is within the 
			feature, resize that feature and shift back the rest.
			*/
			for (var i:int = 0; i < tempLocations.length; i++) {
				if (!shifting) { // search phase
					currentLocation = tempLocations[i];
					if (normalizedPosition >= currentLocation.start && normalizedPosition <= currentLocation.end) {
						// position within this location. Grow this location and shift the rest
						currentLocation.end += insertLength;
						shifting = true;
						continue;
					} else if (normalizedPosition < currentLocation.start) {
						// shift this and the rest
						currentLocation.start += insertLength;
						currentLocation.end += insertLength;
						shifting = true;
						continue;
					}
				} else { // shifting phase
					currentLocation.start += insertLength;
					currentLocation.end += insertLength;
				}
			}
			locations = deNormalizeLocations(tempLocations, offset, maxLength + insertLength, circular);

			return this;
		}
	
		/**
		 * Delete basepairs, and update locations accordingly. Alter only the affected location.
		 * 
		 * @author Timothy Ham
		 */
		public function deleteAt(cutStart:int, cutLength:int, maxLength:int, circular:Boolean):Annotation
		{
			if (cutLength < 1) {
				return this;
			}
			var expectedNewLength:int = -1;
			
			var shifting:int = 0;
			var offset:int = locations[0].start;
			var normalizedCutStart:int = cutStart - offset;
			var circularAdjustment:int = 0;
			if (end < start && cutStart >= 0 && cutStart < end) { 
				// cut is happening at wrapped around tail end of feature
				normalizedCutStart += maxLength;
				circularAdjustment = cutLength;
			}
			var newMinimum:int = 0;
			var normalizedCutEnd:int = normalizedCutStart + cutLength;			
			var tempLocations:Vector.<Location> = getNormalizedLocations(maxLength);
			
			var normalizedStart:int = tempLocations[0].start;
			var normalizedEnd:int = tempLocations[tempLocations.length - 1].end;
			if (normalizedCutStart < normalizedStart && normalizedCutEnd <= normalizedStart) {
				expectedNewLength = normalizedEnd - normalizedStart;
			} else if (normalizedCutStart < normalizedStart && normalizedCutEnd <= normalizedEnd) {
				expectedNewLength = normalizedEnd - (normalizedCutEnd);
			} else if (normalizedCutStart >= normalizedStart && normalizedCutEnd <= normalizedEnd) {
				expectedNewLength = normalizedEnd -normalizedStart - cutLength;
			} else if (normalizedCutStart <= normalizedEnd && normalizedCutEnd >= normalizedEnd) {
				expectedNewLength = normalizedCutStart - normalizedStart;
			}
			
			if (normalizedCutStart < tempLocations[0].start) {
				if (normalizedCutStart + cutLength >= tempLocations[0].start) {
					newMinimum = normalizedCutStart;
				} else if (normalizedCutStart + cutLength <= tempLocations[0].start) {
					newMinimum = tempLocations[0].start - cutLength;
				}
			} else {
				newMinimum = tempLocations[0].start;
			}
			
			// if deletion happened before feature, shift only, no delete
			if (normalizedCutEnd <= tempLocations[0].start) {
				for (var j:int = 0; j < tempLocations.length; j++) {
					tempLocations[j].start -= cutLength;
					tempLocations[j].end -= cutLength;
				}
			} else {
				// do deletions
				var currentLocation:Location;
	
				shifting = 0;
				
				for (var i:int = 0; i < tempLocations.length; i++) {
					currentLocation = tempLocations[i];
					if (shifting == 0) {
						if (normalizedCutStart >= currentLocation.end) {
							continue;
						} else if (normalizedCutEnd <= currentLocation.start && normalizedCutStart <= currentLocation.start && cutLength > 0) { 
							// cuts are left, but is all before this location. Switch to shifting
							currentLocation.start -= cutLength;
							currentLocation.end -= cutLength;
							shifting = cutLength;
						} else if (normalizedCutEnd <= currentLocation.end) {
							if (normalizedCutStart < currentLocation.start) {
								// cut starts before and ends within this location
								currentLocation.start = normalizedCutStart;
								currentLocation.end -= cutLength;
								shifting = cutLength;
							} else if (normalizedCutStart >= currentLocation.start) { 
								// cut entirely within this location
								currentLocation.end -= cutLength;
								shifting = cutLength;
							}
						} else if (normalizedCutEnd > currentLocation.end) { 
							if (normalizedCutStart < currentLocation.start) { 
								// cut starts before this location, and ends after this location
								currentLocation.start = normalizedCutStart;
								currentLocation.end = normalizedCutStart;
							} else if (normalizedCutStart >= currentLocation.start) { 
								// cut starts within this location and continues after this location
								currentLocation.end = normalizedCutStart;
							}
						}
					} else { // shifting
						currentLocation.start -= shifting;
						currentLocation.end -= shifting;
					}
				} // end for (var i:int = 0; i < tempLocations.length; i++) {
			}

			// remove zero length locations and combine locations that are next to each other
			var combinedLocations:Vector.<Location> = new Vector.<Location>();
			for (i = 0; i < tempLocations.length; i++) {
				if (combinedLocations.length == 0) {
					if (tempLocations[i].length > 0) {
						combinedLocations.push(tempLocations[i]);	
					}
					continue;
				}
				if (combinedLocations[combinedLocations.length - 1].end == tempLocations[i].start) {
					combinedLocations[combinedLocations.length - 1].end = tempLocations[i].end;
				} else if (tempLocations[i].length > 0) {
					combinedLocations.push(tempLocations[i]);
				}
			}
			
			// first and last location must fill the length of the feature.
			if (combinedLocations[0].start > newMinimum) {
				combinedLocations[0].start = newMinimum;
			}
			
			if (combinedLocations[combinedLocations.length - 1].end != newMinimum + expectedNewLength) {
				combinedLocations[combinedLocations.length - 1].end = newMinimum + expectedNewLength;
			}
			
			locations = deNormalizeLocations(combinedLocations, offset, maxLength - cutLength, circular, circularAdjustment);

			return this;
		}
		
		public function reverseLocations(newStartIndex:int, newMaxLength:int, circular:Boolean):Annotation
		{
			var tempLocations:Vector.<Location> = getNormalizedLocations(newMaxLength);
			tempLocations = reverseNormalizedLocations(tempLocations);
			tempLocations = deNormalizeLocations(tempLocations, newStartIndex, newMaxLength, circular);
			
			locations = tempLocations;
			return this;
		}
		
		// private methods
		/**
		 * @return zero normalized locations
		 * 
		 * @author Timothy Ham
		 * 
		 */
		private function getNormalizedLocations(maxLength:int):Vector.<Location>
		{
			if (locations.length == 0) {
				return null;
			}
			
			var result:Vector.<Location> = new Vector.<Location>();
			var offset:int = locations[0].start;
			var newStart:int = 0;
			var newEnd:int = 0;
			var location:Location;
			
			for (var i:int = 0; i < locations.length; i++) {
				location = locations[i];	
				newStart = location.start - offset;
				if (newStart < 0) {
					newStart += maxLength;
				}
				newEnd = location.end - offset;
				if (newEnd < 0) {
					newEnd += maxLength;
				}
				result.push(new Location(newStart, newEnd));
			}
			return result;
		}
		
		/**
		 * Denormalize location from zero based to offset, calculating circularity if needed.
		 * 
		 * @author Timothy Ham
		 */
		private function deNormalizeLocations(tempLocations:Vector.<Location>, offset:int, maxLength:int, circular:Boolean, circularAdjustment:int = 0):Vector.<Location>
		{
			if (tempLocations.length == 0) {
				return null;
			}
			
			var result:Vector.<Location> = new Vector.<Location>();
			var newStart:int;
			var newEnd:int;
			var location:Location;
			
			for (var i:int = 0; i < tempLocations.length; i++) {
				location = tempLocations[i];
				newStart = location.start + offset;
				if (circular && newStart > maxLength) {
					newStart -= maxLength + circularAdjustment;
				} else if (circular) {
					newStart -= circularAdjustment;
				}
				
				newEnd = location.end + offset;
				if (circular && newEnd > maxLength) {
					newEnd -= maxLength + circularAdjustment;
				} else if (circular) {
					newEnd -= circularAdjustment;
				}
				
				// On rare occasions, the calculated value is two circular distances away. Handle this case.
				if (circular && location.start + offset == maxLength && location.end + offset == maxLength + maxLength) {
					newStart = 0;
					newEnd = maxLength;
				}

				result.push(new Location(newStart, newEnd));
			}
			return result;
		}

		/**
		 * Reverses locations. This function assumes normalized locations, meaning it will not
		 * handle locations that go over zero properly, although it will calculate non-zero
		 * offset.
		 * 
		 * @author Timothy Ham
		 */
		private function reverseNormalizedLocations(tempLocations:Vector.<Location>):Vector.<Location>
		{
			if (tempLocations.length == 0) {
				return null;
			}
			var result:Vector.<Location> = new Vector.<Location>();
			var offset:int = tempLocations[0].start;
			var location:Location
			var length:int;
			var featureLength:int = tempLocations[tempLocations.length - 1].end - offset;
			var newStart:int;
			
			for (var i:int = tempLocations.length - 1; i > -1; i--) {
				location = tempLocations[i];
				length = location.end - location.start;
				newStart = location.end - featureLength;
				
				result.push(new Location(newStart, newStart + length)); 
			}
			
			return result;
		}
		
		/**
		 * @return The index of Location. -1 if not within a Location.
		 * 
		 * @author Timothy Ham
		 */
		private function getOverlappingLocationIndex(index:int):int
		{
			var result:int = -1;
			
			for (var index:int; index < locations.length; index++) {
				var location:Location = locations[index];
				if (index >= location.start && index <= location.end) {
					result = index;
					break;
				} 
			}
			
			return result;
		}
	}
}