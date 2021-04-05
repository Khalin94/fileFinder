<!--**      Program Name : utils.jsp**      Program Date : 2004. 05.19.**      Last    Date : 2004. 05.19.**      Programmer   : Kim Kang Soo**      Description  : 쓰리소프트에서 jsp유틸 관련 화일**--><%!
public String replace(String str, String oldString, String newString)
{
	for(int index = 0; (index = str.indexOf(oldString, index)) >= 0; index += newString.length())
		str = str.substring(0, index) + newString + str.substring(index + oldString.length());
	return str;
}	public  String replace_v1(String str, String pattern, String replace) {					if(str == null || str.length() < 1)  return ""; 				int s = 0; 			int e = 0; 			StringBuffer result = new StringBuffer();						while ((e = str.indexOf(pattern, s)) >= 0) { 				result.append(str.substring(s, e)); 				result.append(replace); 				s = e+pattern.length(); 			} 			result.append(str.substring(s)); 			return result.toString(); 		}

public String toHan(String src)
{
	String sRet = src;
	try {
		sRet = new String(src.getBytes("8859_1"),"EUC_KR");
	} catch (Exception e) {
	}
	
	return sRet;
}	

public String toEng(String src)
{
	String sRet = src;
	try {
		sRet = new String(src.getBytes("EUC_KR"),"8859_1");
	} catch (Exception e) {
	}
	
	return sRet;
}

public String PrintHexa(String s) {
	String s1 = new String("");
	try {
		byte[] b = s.getBytes("8859_1");
		for (int i=0 ; i<b.length ;i++ ) {
			s1 = s1 + byteToHex(b[i]) + " ";
		}	} catch (Exception e) {
	}
	return s1;
}  

public String byteToHex(byte b) {
	char hexDigit[] = {
		'0', '1', '2', '3', '4', '5', '6', '7',
		'8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
	};
	char[] array = { hexDigit[(b >> 4) & 0x0f], hexDigit[b & 0x0f] };
	return new String(array);
} 

public String toAscii(String s)
{
	String s1 = PrintHexa(s);
	if (s1.lastIndexOf("3f") >= 0) {
		return toEng(s);
	} else {
		return s;
	}
}

public String toMulti(String s)
{
	String s1 = PrintHexa(s);
	if (s1.lastIndexOf("3f") >= 0) {
		return s;
	} else {
		return toHan(s);
	}
}
%>
