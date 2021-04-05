<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>


<html>
<head>
<title>문자전송 테스트</title>
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
						<td width="100%" class="title" height="30">&nbsp;&nbsp;&nbsp;문자전송 테스트</td>					
					</tr>
				</table>

				<!---------------------------------------------------------------- START --------------------------------------------------------------->								
				<table>
				<tr>
				<td>&nbsp;&nbsp;</td>
				<td>
				<table>
				<form name="form1" method="get" action="SmsProc.jsp">
					<input type="hidden" name="cmd" value="create">				
					<tr>
						<td>
						  <table>
						    <tr> 
						      <td width=100 bgcolor="#CCCCCC" align="center"><b>전송폰번호</b></td>
						      <td colspan="2">
						        <input type="text" class="textbox" name="sendphoneno" size="30"  value="">
						      </td>  
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>회신번호</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="returnno" size="30"  value="">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>전송상태</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sendstatus" size="30"  value="1">
   						        전송상태 : 전송대기='9'   전송요청 = '1'
   						        전자결재를 타면 9로 그렇지 않으면 1로 parameter값을 넘긴다.
						      </td>
						    </tr>						    						    
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>메시지</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="smsmsg" size="40" maxlength="80" value="">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>시스템구분</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="systemgbn" size="30"  value="S13001">
   						        S13001(서류제출), S13002(정보관리),S13003(전자결재), S13004(홈페이지)
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>서비스구분</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="servicegbn" size="30"  value="001">
   						        001(서류요구), 002(서류제출), 003(서류요구목록수정), 004(서류요구목록삭제)
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>부서ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="deptgbn" size="30"  value="">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>부서명</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="deptnm" size="30"  value="">
						      </td>
						    </tr>						    
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>사용자ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="userid" size="30"  value="ADMIN">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>사용자명</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="usernm" size="30"  value="관리자">
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
			<td width="980" height="45" align="center" colspan="2"><!--%@ include file="/common/bottom.jsp" %--> </td>
		</tr>
	</table>
</body>
</html>