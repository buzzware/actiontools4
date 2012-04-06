package flexUnitTests
{

	import au.com.buzzware.actiontools4.code.BaseConfig2;
	import au.com.buzzware.actiontools4.code.ObjectAndArrayUtils;
	
	import flexunit.framework.Test;
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.IsNullMatcher;
	import org.hamcrest.object.equalTo;

	public class ConfigTests {

		public static const SOURCE_A: Object = {
			one: true,
			two: "2",
			three: 3.0,
			four: 4
		};

		[Test]
		public function testBaseConfigMergeProperties(): void {
			var bc: BaseConfig2 = new BaseConfig2();
			bc.mergeProperties(SOURCE_A)
			assertThat(ObjectAndArrayUtils.clone_dynamic_properties(bc), equalTo(SOURCE_A))
		}
		
		
	}
}