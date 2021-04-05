<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.db.sql.SqlRequestBox" %>

<%
	String strMethod = StringUtil.getEmptyIfNull(request.getParameter("method"));
	String strSelected1 = " checked";
	String strSelected2 = "";
	String strDivDisplay = "none";
	if("1".equals(strMethod)) {
		strSelected1 = "";
		strSelected2 = " checked";
		strDivDisplay = "";
	} 
%>

<html>
<head>
<title>의정자료 전자유통 시스템 - 교육용 테스트 자료 일괄 삭제 폼</title>

<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">
	function showDiv() {
		document.all.formDiv.style.display = '';
	}

	function hiddenDiv() {
		document.all.formDiv.style.display = 'none';
	}

	function doSubmit() {
		var f = document.delForm;
		if(f.method.value == "0") {
			f.fieldType.value = "";
			f.fieldValue.value = "";
		} else if (f.method.value == "1") {
			if(f.fieldType.value.length == 0) {
				alert("검색 대상 컬럼을 지정해 주세요.");
				f.fieldType.focus();
				return;
			}
			if(f.fieldValue.value.length == 0) {
				alert("검색할 내용을 입력해 주세요.");
				f.fieldValue.focus();
				return;
			}
		}
		if(f.pwd.value.length == 0) {
			alert("비밀번호를 입력해 주세요.");
			f.pwd.focus();
			return;
		}
		if(confirm("테스트 데이터를 삭제하시겠습니까?")) f.submit();
	}
</script>

</head>

<body leftmargin="0" topmargin="0">
	<CENTER>
	<p><BR></p>
	<font style="font-family:HY헤드라인M; font-size:18px; color:darkblue;">
		의정자료 전자유통 시스템<BR>
	</font>
	<font style="font-family:HY헤드라인M; font-size:24px; color:darkblue; font-weight:bold;">
		교육용 테스트 데이터 일괄 삭제 
	</font>
	<p>

<FORM name="delForm" method="post" action="deleteTestDataProc.jsp" style="margin:0px">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="600" align="left" height="50">
				* 교육 상에 발생한 테스트 데이터를 일괄 삭제하기 위한 페이지 입니다.<BR>
				* 삭제 방법을 선택하신 후 [확인] 버튼을 클릭해 주세요.
			</td>
		</tr>
		<tr>
			<td align="left" style="border:1px solid #808080;padding:5px">
				<input type="radio" name="method" value="0"<%= strSelected1 %> onClick="javascript:hiddenDiv()"> '교육01' 과 같은 형태로 임시 생성한 이용자가 교육(테스트) 과정 중에 작업한 데이터 일괄 삭제
				<br>
				<input type="radio" name="method" value="1"<%= strSelected2 %> onClick="javascript:showDiv()">  특정 아이디 혹은 이름을 가진 이용자가 작업한 데이터 일괄 삭제
				<p>
				<DIV ID="formDiv" style="width:580px;height:40px;display:<%= strDivDisplay %>"> 
					<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0"> 
						 <tr>
							<td height="30" width="580">
								&nbsp;&nbsp;&nbsp;
								<select name="fieldType">
									<option value="user_id">:: 이용자 ID :: </option>
									<option value="user_nm">:: 이용자 이름 :: </option>
								</select>
								<input type="text" size="30" name="fieldValue">
							</td>
						</tr> 
					</table> 
				</DIV> 
				<p>
				&nbsp;* 비밀번호 : <input type="password" name="pwd" value="" size="15"><p>
				<input type="button" name="btn" value="SUBMIT" onClick="javascript:doSubmit()" style="cursor:hand; font-size:11px; font-family:Verdana,돋움; background-color:white; color:#909090">
			</td>
		</tr>
	</table>
</FORM>	

	</CENTER>
</body>

</html>