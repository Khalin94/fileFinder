<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%
	String webURL = ""; //http 주소
	try {
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티
		webURL = objConfig.get("nads.dsdm.url");
	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
	
%>

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
				<form name="form1" method="post" action="SmtpWebProc.jsp">
					<input type="hidden" name="cmd" value="create">
					<tr>
						<td>
						  <table>
				 		    <tr>
				 		    	<a>메일발송예약 (TS_MAILQUEUE) 테이블에 저장</a>
				 		    </tr>						  
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>수신자ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="rid" size="40" maxlength="80" value="T000001">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>수신자명</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="rname" size="30"  value="수신자">
						      </td>
						    </tr>						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>수신자메일주소</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="rmail" size="30"  value="hhh@ggg.co.kr">
						      </td>
						    </tr>	
				 		    <tr>
				 		    </tr>
				 		    <tr>
				 		    </tr>
				 		    <tr>
				 		    	<td><a>발송그룹저장 (TS_RECIPIENTINFO) 테이블에 저장</a></td>
				 		    </tr>						  						    						   						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sid" size="40" maxlength="80" value="G000002">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자명</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sname" size="30"  value="발신자">
						      </td>
						    </tr>						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자메일주소</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="smail" size="30"  value="ggg@ttt.co.kr">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>제목</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="subject" size="60"  value="의정자료 전자유통 시스템 자료요구">
						      </td>
						    </tr>						    						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>내용</b></td>						      
						      <td colspan="2">
						        <TEXTAREA  name="contents" cols="103" rows="8" value=""><%=webURL%>/newsletter/ReqOffiDoc.jsp?title=서류요구&sendname=김동수&reqname=안상수의원실&reqtitle=2004년 건설교통부 예산 사용내역 관련&reqtel=02-788-2060&reqmail=Master@assembly.go.kr</TEXTAREA>        
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
   						        001(서류요구), 002(서류제출), 003(서류요구목록수정), 004(서류요구목록삭제), 005(결재완료)
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>전송상태</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="status" size="30"  value="0">
   						        전송상태 : 전송대기='9'   전송요청 = '0'
   						        전자결재를 타면 9로 그렇지 않으면 0으로 parameter값을 넘긴다.
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>부서ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="deptgbn" size="30"  value="9710137">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>부서명</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="deptnm" size="30"  value="입법정보화 담당관실">
						      </td>
						    </tr>	
						    <tr>
						      <td colspan="2" bgcolor="#CCCCCC" align="center"><b>## 위의 정보는 필수 값 입니다.</b></td>
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
			<td width="980" height="45" align="center" colspan="2"><!--%@ include file="/common/bottom.jsp" %--></td>
		</tr>
	</table>
</body>

</html>