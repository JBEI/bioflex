package flexUnitTests
{
	import org.flexunit.Assert;
	import org.jbei.bio.sequence.common.Annotation;
	import org.jbei.bio.sequence.common.Location;
	
	/**
	 * @author Timothy Ham
	 */
	public class AnnotationTestCases
	{		
		private var _annotation:Annotation;
		private var _locations:Vector.<Location>;
		[Before]
		public function setUp():void
		{
			_annotation = new Annotation();
			_locations = new Vector.<Location>();
			_locations.push(new Location(10, 20));
			_locations.push(new Location(30, 40));
			_locations.push(new Location(50, 60));
			_annotation.locations = _locations;
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
		public function testeDeleteAtBeforeFirst():void
		{
			_annotation.deleteAt(-10, 5, 100, false);
			Assert.assertEquals(3, _annotation.locations.length);
			Assert.assertEquals(5, _annotation.locations[0].start);
			Assert.assertEquals(15, _annotation.locations[0].end);
			Assert.assertEquals(25, _annotation.locations[1].start);
			Assert.assertEquals(35, _annotation.locations[1].end);
			Assert.assertEquals(45, _annotation.locations[2].start);
			Assert.assertEquals(55, _annotation.locations[2].end);
				
		}
		
		[Test]
		public function testDeleteAtFrontPartFirst():void
		{
			// delete front part of first
			_annotation.deleteAt(10, 5, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(10, _annotation.locations[0].start);
			Assert.assertEquals(15, _annotation.locations[0].end);
			Assert.assertEquals(25, _annotation.locations[1].start);
			Assert.assertEquals(35, _annotation.locations[1].end);
			Assert.assertEquals(45, _annotation.locations[2].start);
			Assert.assertEquals(55, _annotation.locations[2].end);
		}
		
		[Test]
		public function testDeleteAtMiddleFirst():void
		{
			// delete middle of frst
			_annotation.deleteAt(12, 5, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(10, _annotation.locations[0].start);
			Assert.assertEquals(15, _annotation.locations[0].end);
			Assert.assertEquals(25, _annotation.locations[1].start);
			Assert.assertEquals(35, _annotation.locations[1].end, 35);
			Assert.assertEquals(_annotation.locations[2].start, 45);
			Assert.assertEquals(_annotation.locations[2].end, 55);
		}
		
		[Test]
		public function testDeleteAtFirstandGap():void
		{	
			// delete all of first, extend into gap
			_annotation.deleteAt(10, 15, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 10);
			Assert.assertEquals(_annotation.locations[0].end, 25);
			Assert.assertEquals(_annotation.locations[1].start, 35);
			Assert.assertEquals(_annotation.locations[1].end, 45);
		}
		
		[Test]
		public function testDeleteAtFirstandPartSecond():void
		{
			// delete all of first, extend into second
			_annotation.deleteAt(10, 25, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 10);
			Assert.assertEquals(_annotation.locations[0].end, 15);
			Assert.assertEquals(_annotation.locations[1].start, 25);
			Assert.assertEquals(_annotation.locations[1].end, 35);
		}
		
		[Test]
		public function testDeleteAtEndFirst():void
		{
			// delete end part of first
			_annotation.deleteAt(15, 5, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(_annotation.locations[0].start, 10);
			Assert.assertEquals(_annotation.locations[0].end, 15);
			Assert.assertEquals(_annotation.locations[1].start, 25);
			Assert.assertEquals(_annotation.locations[1].end, 35);
			Assert.assertEquals(_annotation.locations[2].start, 45);
			Assert.assertEquals(_annotation.locations[2].end, 55);
		}
		
		[Test]
		public function testDeleteAtEndFirstPartGap():void
		{
			// delete end part of first, front part of gap
			_annotation.deleteAt(15, 10, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(_annotation.locations[0].start, 10);
			Assert.assertEquals(_annotation.locations[0].end, 15);
			Assert.assertEquals(_annotation.locations[1].start, 20);
			Assert.assertEquals(_annotation.locations[1].end, 30);
			Assert.assertEquals(_annotation.locations[2].start, 40);
			Assert.assertEquals(_annotation.locations[2].end, 50);
		}

		[Test]
		public function testDeleteAtWithinGap():void
		{
			// delete end part of first, front part of gap
			_annotation.deleteAt(22, 5, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 3);
			Assert.assertEquals(_annotation.locations[0].start, 10);
			Assert.assertEquals(_annotation.locations[0].end, 20);
			Assert.assertEquals(_annotation.locations[1].start, 25);
			Assert.assertEquals(_annotation.locations[1].end, 35);
			Assert.assertEquals(_annotation.locations[2].start, 45);
			Assert.assertEquals(_annotation.locations[2].end, 55);
		}
		
		[Test]
		public function testDeleteAtPartialFirstSecond():void
		{
			// delete end part of first, part of second
			_annotation.deleteAt(15, 20, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 10);
			Assert.assertEquals(_annotation.locations[0].end, 20);
			Assert.assertEquals(_annotation.locations[1].start, 30);
			Assert.assertEquals(_annotation.locations[1].end, 40);
		}
		
		[Test]
		public function testDeleteAtSecondPartialThird():void
		{
			// delete second
			_annotation.deleteAt(25, 20, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 10);
			Assert.assertEquals(_annotation.locations[0].end, 20);
			Assert.assertEquals(_annotation.locations[1].start, 30);
			Assert.assertEquals(_annotation.locations[1].end, 40);
		}
		
		[Test]
		public function testDeleteAtGapAtEnd():void
		{
			// delete with gap left over at the end
			_annotation.deleteAt(45, 15, 100, false); 
			Assert.assertEquals(_annotation.locations.length, 2);
			Assert.assertEquals(_annotation.locations[0].start, 10);
			Assert.assertEquals(_annotation.locations[0].end, 20);
			Assert.assertEquals(_annotation.locations[1].start, 30);
			Assert.assertEquals(_annotation.locations[1].end, 45);
		}
		
		[Test]
		public function testInsertAt():void
		{
			//Assert.fail("Test method not yet implemented");
		}
		
	}
}