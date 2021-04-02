<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>


<html>
<head>
<title>전자우편 테스트</title>
<link href="/css/global.css"  rel="stylesheet" type="text/css" />
<head>

<body leftmargin="0" topmargin="0">
	<table border="0" cellpadding="0" cellspacing="0" width="980" height="500">
		<tr>
			<td width="980" height="90" align="center" colspan="2"><%@ include file="/common/top.jsp" %></td>
		</tr>
		<tr>
			<td width="190" align="center" valign="top"><%@ include file="/common/menu.jsp" %></td>
			<td width="790" valign="top">
				<!-- 여기부터 본문 내용을 입력해 주세요 -->
				
				<!-- 현재 위치 Navigation -->
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td height="1" class="e1"></td> 
					</tr>
					<tr>
					</tr>
					<tr>
						<td height="1" class="e1"></td>
					</tr>
				</table>

				<!-- 현재 페이지 타이틀 이미지(or 텍스트) -->
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="100%" class="title" height="30">&nbsp;&nbsp;&nbsp;전자우편 테스트</td>					
					</tr>
				</table>

				<!---------------------------------------------------------------- START --------------------------------------------------------------->								
				<table>
				<tr>
				<td>&nbsp;&nbsp;</td>
				<td>
				<table>
				<form name="form1" method="get" action="SmtpTestProc.jsp">
					<input type="hidden" name="cmd" value="create2">				
					<tr>
						<td>
						  <table>
						    <tr> 
						      <td width=60 bgcolor="#CCCCCC" align="center"><b>메시지ID</b></td>
						      <td colspan="2">
						        <input type="text" class="textbox" name="mid" size="30"  value="1">
						      </td>  
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>서비스ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="tid" size="30"  value="1">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sid" size="40" maxlength="80" value="yjzzz">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자명</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sname" size="30"  value="권영진">
						      </td>
						    </tr>						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자메일주소</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="smail" size="30"  value="yjzzz@unidocs.co.kr">
						      </td>
						    </tr>						    						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>제목</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="subject" size="30"  value="내용">
						      </td>
						    </tr>						    						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>내용</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="contents" size="30"  value="제목">
						      </td>
						    </tr>						    						    						    
						  </table>
						  <table>						  
						   	<tr>
						  	  <td align="center"> 
								<input type="submit" value="저장" style="cursor:hand" >&nbsp;								
								<input type="reset" value="취소" style="cursor:hand" >&nbsp;						
							  </td>
							</tr>
						  </table>							
				 		    <tr>
				 		    </tr>
				 		    <tr>
				 		    </tr>
				 		    <tr>
				 		    </tr>						  
						</td><!--목록 리스트 끝  -->
					</tr>
				</form>
				</table>
				</td>
				</tr>
				</table>				       								
				<!---------------------------------------------------------------- FINISH  --------------------------------------------------------------->

				<!-- 여기까지 본문 내용을 입력해 주세요 -->
			</td>
		</tr>
		<tr>
			<td width="980" height="45" align="center" colspan="2"><%@ include file="/common/bottom.jsp" %> </td>
		</tr>
	</table>
</body>

</html>