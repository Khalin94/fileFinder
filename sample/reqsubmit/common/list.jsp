<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<html>
<%
	String strAnsId = "1";
%>
<head>
<title>바인더 목록에 추가</title>
<script language="javascript">
   closetime = 5;
   
   function openWin(){
		window.open("http://10.201.7.49/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=1&DOC=PDF","OpenPDF",
		"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );	
   }
   function RAnsDocOpen(){
		window.open("http://10.201.7.49/reqsubmit/common/RAnsDoc.jsp","답변서보기",	
		"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );	
   }
   function addBinder(){
		 if(confirm("바인더 목록에 추가하시겠습니까 ?")==true){
			   addBind = window.open("http://10.201.7.49/reqsubmit/common/addBinder.jsp?ReqInfoIDs=1","addBind",
				   "resizable=no,menubar=no,status=no,titlebar=yes,	      scrollbars=no,location=no,toolbar=no,height=200,width=300");
				   if (closetime) 
						setTimeout("addBind.close();", closetime*1000);		
				   
		 }else{
			window.close();
		 }
   }
    function bindList(){
	   window.open("http://10.201.7.49/reqsubmit/common/bindList.jsp?binderSortField=ANS_DT&binderSortMtd=DESC&binderPageNum=1"
		,"binderList","resizable=YES,menubar=YES,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=YES,height=600,width=900" );	
   
   }
</script>
</head>
<body leftmargin="0" topmargin="0">   
	<input type=button onclick="openWin();" value="팝업창 열기"> 	
	<input type=button onclick="RAnsDocOpen();" value="답변서 열기"> 	
	<input type=button onclick="addBinder();" value="바인더 추가"> 	
	<input type=button onclick="bindList();" value="바인더 리스트"> 	
</body>
</html>