public class ExceptionUtils {

	/**
	 *  ClassName LineNumber MethodName
	 * @param throwable
	 * @return
	 */
	public static String getStackException(Throwable throwable) {
		StringBuilder builder = new StringBuilder();
		StackTraceElement[] stackElements = throwable.getStackTrace();
		if (stackElements != null && stackElements.length > 0) {
			for (int i = 0; i < stackElements.length; i++) {
				builder.append("ClassName=" + stackElements[i].getClassName());
				builder.append(",LineNumber=" + stackElements[i].getLineNumber());
				builder.append(",MethodName=" + stackElements[i].getMethodName());
			}
		}
		return builder.toString();
	}
}
