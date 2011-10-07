package flexUnitTests
{
	import org.flexunit.Assert;
	import org.jbei.bio.sequence.common.Annotation;
	import org.jbei.bio.sequence.common.Location;
	
	public class AnnotationTestCases
	{		
		private var _annotation:Annotation;
		private var _locations:Vector.<Location>;
		[Before]
		public function setUp():void
		{
			_annotation = new Annotation();
			_locations = new Vector.<Location>();
			_locations.push(new Location(0, 10));
			_locations.push(new Location(20, 30));
			_locations.push(new Location(40, 50));
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testDeleteAtFrontPartFirst():void
		{
			_annotation.locations = _locations;
			// delete front part of first
			_annotation.deleteAt(0, 5, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 5);
			Assert.assertEquals(_annotation.locations[1].start, 15);
			Assert.assertEquals(_annotation.locations[1].end, 25);
			Assert.assertEquals(_annotation.locations[2].start, 35);
			Assert.assertEquals(_annotation.locations[2].end, 45);
		}
		
		[Test]
		public function testDeleteAMiddleFirst():void
		{
			// delete middle of frst
			_annotation.locations = _locations;
			_annotation.deleteAt(2, 5, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 5);
			Assert.assertEquals(_annotation.locations[1].start, 15);
			Assert.assertEquals(_annotation.locations[1].end, 25);
			Assert.assertEquals(_annotation.locations[2].start, 35);
			Assert.assertEquals(_annotation.locations[2].end, 45);
		}
		
		[Test]
		public function testDeleteAtFirstandGap():void
		{	
			_annotation.locations = _locations;
			// delete all of first, extend into gap
			_annotation.deleteAt(0, 15, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 15);
			Assert.assertEquals(_annotation.locations[1].start, 25);
			Assert.assertEquals(_annotation.locations[1].end, 35);
		}
		
		[Test]
		public function testDeleteAtFirstandPartSecond():void
		{
			_annotation.locations = _locations;
			// delete all of first, extend into second
			_annotation.deleteAt(0, 25, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 5);
			Assert.assertEquals(_annotation.locations[1].start, 15);
			Assert.assertEquals(_annotation.locations[1].end, 25);
		}
		
		[Test]
		public function testDeleteAtEndFirst():void
		{
			_annotation.locations = _locations;
			// delete end part of first
			_annotation.deleteAt(5, 5, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 5);
			Assert.assertEquals(_annotation.locations[1].start, 15);
			Assert.assertEquals(_annotation.locations[1].end, 25);
			Assert.assertEquals(_annotation.locations[2].start, 35);
			Assert.assertEquals(_annotation.locations[2].end, 45);
		}
		
		[Test]
		public function testDeleteAtEndFirstPartGap():void
		{
			_annotation.locations = _locations;
			// delete end part of first, front part of gap
			_annotation.deleteAt(5, 10, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 5);
			Assert.assertEquals(_annotation.locations[1].start, 10);
			Assert.assertEquals(_annotation.locations[1].end, 20);
			Assert.assertEquals(_annotation.locations[2].start, 30);
			Assert.assertEquals(_annotation.locations[2].end, 40);
		}

		[Test]
		public function testDeleteAtWithinGap():void
		{
			_annotation.locations = _locations;
			// delete end part of first, front part of gap
			_annotation.deleteAt(12, 5, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 10);
			Assert.assertEquals(_annotation.locations[1].start, 15);
			Assert.assertEquals(_annotation.locations[1].end, 25);
			Assert.assertEquals(_annotation.locations[2].start, 35);
			Assert.assertEquals(_annotation.locations[2].end, 45);
		}
		
		[Test]
		public function testDeleteAtPartialFirstSecond():void
		{
			_annotation.locations = _locations;
			// delete end part of first, part of second
			_annotation.deleteAt(5, 20, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 10);
			Assert.assertEquals(_annotation.locations[1].start, 20);
			Assert.assertEquals(_annotation.locations[1].end, 30);
		}
		
		[Test]
		public function testDeleteAtSecondPartialThird():void
		{
			_annotation.locations = _locations;
			// delete second
			_annotation.deleteAt(15, 20, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 10);
			Assert.assertEquals(_annotation.locations[1].start, 20);
			Assert.assertEquals(_annotation.locations[1].end, 30);
		}
		
		[Test]
		public function testDeleteAtGapAtEnd():void
		{
			_annotation.locations = _locations;
			// delete with gap left over at the end
			_annotation.deleteAt(35, 15, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 0);
			Assert.assertEquals(_annotation.locations[0].end, 10);
			Assert.assertEquals(_annotation.locations[1].start, 20);
			Assert.assertEquals(_annotation.locations[1].end, 35);
		}
		
		[Test]
		public function testInsertAt():void
		{
			//Assert.fail("Test method not yet implemented");
		}
		
	}
}