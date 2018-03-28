
import org.junit.Test;

/**
 * 
 * @author micolore
 *
 */
public class TestPerformance {

	final static String staticFinalString = "";

	@Test
	public void testString() {

		StringBuffer stringBuffer = new StringBuffer();// 线程安全的缓冲区 没必要
		String nullStr = "";
		System.out.println(stringBuffer.length());
		System.out.println(nullStr.length());
		System.out.println(staticFinalString.length());

		int max = 12;
		String numberString = max + "";
		String valueOfString = String.valueOf(max);
		System.out.println(valueOfString);
		System.out.println(numberString);

	}

	/**
	 * 以x为处理对象
	 * firstEnd-firstStart 直接拼接""
	 * 6283 
	 * twoEnd-twoStart
	 * 3345
	 * 
	 * 固定处理对象
	 * firstEnd-firstStart 使用String.valueOf(),内部使用toString()
	 * 2
     * twoEnd-twoStart
     * 1481
     * 
     * 结论:
     * 处理同一个对象转换字符串，直接拼""效率比较快
     * 如果是处理的动态的变量，还是优先使用String.valueOf();
     *
	 */
	@Test
	public void manyString() {
		long firstStart = getCurrentTime();
		for (Integer x = 0; x < 100000000; x++) {
			String numberString = x + "";//调用toString()
		}
		long firstEnd = getCurrentTime();
		System.out.println("firstEnd-firstStart"+(firstEnd - firstStart));
		
		long twoStart = getCurrentTime();
		for (Integer x = 0; x < 100000000; x++) {
			String valueOfString = String.valueOf(x);//1.转换成object 2.调用toString()
		}
		long twoEnd = getCurrentTime();
		System.out.println("twoEnd-twoStart"+(twoEnd - twoStart));
		
		long secondStart = getCurrentTime();
		for (Integer x = 0; x < 100000000; x++) {
			String valueOfString = x.toString();
		}
		long secondEnd = getCurrentTime();
		System.out.println("secondEnd-secondStart"+(secondEnd - secondStart));

	}
	/**
	 * 应该考量的点是什么
	 * 
	 * 1. 初始化的速度
	 *    并不是变量处理完之后就不去管后面的操作是不是还有用这个变量
	 * 2. 调用的速度
	 * 3. 销毁的速度
	 * 
	 * 环境是不是多线程
	 * 
	 */
	
	@Test
	public void testBuffef(){
		long currentTimeStart = getCurrentTime();
		for(int x=0;x<10000000;x++){
			StringBuffer stringBuffer = new StringBuffer();// 线程安全的缓冲区 没必要
		}
		long currentTimeEnd = getCurrentTime();
		System.out.println("stringBuffer:"+(currentTimeEnd-currentTimeStart));
		
		long currentTimeStartTwo = getCurrentTime();
		for(int x=0;x<10000000;x++){
			StringBuilder stringBuilder = new StringBuilder();// 线程安全的缓冲区 没必要
		}
		long currentTimeEndTwo = getCurrentTime();
		System.out.println("stringBuilder:"+(currentTimeEndTwo-currentTimeStartTwo));
	}
	
	public static long getCurrentTime(){
	
		return System.currentTimeMillis();
	}
	
}
