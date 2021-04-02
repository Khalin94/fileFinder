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
<script>
	function dosubmit(){
		if(document.form1.stt_cd.value == ""){
			alert("전송그룹을 선택해 주세요");
			return;
		}
		if(document.form1.sname.value == ""){
			alert("발신자명을 입력해주세요.");
			return;
		}
		if(document.form1.smail.value == ""){
			alert("발신자주소를 입력해주세요.");
			return;
		}
		if(document.form1.subject.value == ""){
			alert("제목을 입력해주세요");
			return;
		}
		if(document.form1.contents.value == ""){
			alert("발신내용을 입력해주세요.");
			return;
		}

		if(confirm("발송하시겠습니까?")) {
			document.form1.submit();
		}else{
			return;
		}
		
	}
</script>
</head>

<body leftmargin="0" topmargin="0">
	<table border="0" cellpadding="0" cellspacing="0" width="980" height="500">
		<tr>
			<td width="980" height="90" align="center" colspan="2"></td>
		</tr>
		<tr>
			<td width="190" align="center" valign="top"></td>
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
				<form name="form1" method="post" action="SmtpWebAllProc.jsp">
					<input type="hidden" name="cmd" value="create">
					<tr>
						<td>
						  <table>
				 		    <tr>
				 		    	<a>메일발송예약 (TS_MAILQUEUE) 테이블에 저장</a>
				 		    </tr>						  
						    <tr> 
						      <td width=100 bgcolor="#CCCCCC" align="center"><b>전송그룹</b></td>
						      <td colspan="2">
						        <select name="stt_cd">
									<option value="">선택하세요</option>
									<option value="001">정상</option>
									<option value="005">가입신청</option>
									<option value="006">가입승인</option>
								</select>
						      </td>  
						    </tr>	
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sid" size="40" maxlength="80" value="ADMIN">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자명</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sname" size="30"  value="">
						      </td>
						    </tr>						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>발신자메일주소</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="smail" size="30"  value="">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>제목</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="subject" size="60"  value="">
						      </td>
						    </tr>						    						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>내용</b></td>						      
						      <td colspan="2">
						        <TEXTAREA  name="contents" cols="103" rows="8" value="">http://naps.assembly.go.kr/newsletter/SendAllDoc.jsp</TEXTAREA>        
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
								<input type="button" value="저장" style="cursor:hand" onclick="dosubmit()">&nbsp;							
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