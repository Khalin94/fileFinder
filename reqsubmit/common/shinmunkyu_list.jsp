<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<html>
<%
	String strAnsId = "1";
%>
<head>
<title>신문규 작업 리스트</title>
<script language="javascript">
   closetime = 5;


   function openWin(){
	   //0000000341 ,0000000235 . 0000000242
		window.open("http://10.201.19.148:7001/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=0000000242&DOC=PDF","OpenPDF",
		"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
   }

   function DLOrginalFile(formName){

	    var varAction = formName.action;
		//var linkPath = "/responseDOC?DOC=0000000072.doc&YEAR=2004&ORGBOXID=0000000072&FName=2004_요구.doc";


		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=0000000235&DOC=DOC" ;
		formName.action=linkPath;
		formName.submit();
		formName.action = varAction;

		//window.open("http://10.201.19.148:7001/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=6&DOC=DOC","DowloadOrginalDocFile",
		//"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
   }

   function RAnsDocOpen(){
		window.open("http://10.201.19.148:7001/reqsubmit/common/AnsDocView.jsp?ReqBoxId=0000000222","답변서보기",
		"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
   }
  /* function addBinder(test){
		 if(confirm("바인더 목록에 추가하시겠습니까 ?")==true){
			   addBind =  window.open("http://10.201.7.49/reqsubmit/80_bindreqlist/AddBinder.jsp?ReqInfoIDs=0000000190","addBind",
				   "resizable=no,menubar=no,status=no,titlebar=yes,	      scrollbars=no,location=no,toolbar=no,height=247,width=150");
				   if (closetime)
						setTimeout("addBind.close();", closetime*1000);

		 }else{
			window.close();
		 }
   }*/
   function ReqDocOpen(){
		window.open("http://10.201.19.148:7001/reqsubmit/common/ReqDocView.jsp?ReqBoxId=0000000222&ReqTp=001","ReqDocView",
		"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
   }
   function bindList(){
	   window.open("http://10.201.19.148:7001/reqsubmit/80_bindreqlist/BindList.jsp?binderSortField=ANS_DT&binderSortMtd=DESC&binderPageNum=1"
		,"binderList","resizable=YES,menubar=YES,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=YES,height=600,width=900" );

   }

   function GovSubmitList(){
	   window.open("http://10.201.19.148:7001/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp?strGovSubmtDataSortField=REG_DT&strGovSubmtDataSortMtd=DESC&strGovSubmtDataPageNum=1"
		,"GovSubmitDataBox","resizable=YES,menubar=YES,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=YES,height=600,width=1024" );
   }



    function addBinder(formName){
   		 if(hashCheckedReqInfoIDs(formName)==false){
   		 	return false;
   		 }
		 if(confirm("바인더 목록에 추가하시겠습니까 ?")==true){
			   addBind = window.open("about:blank","addBind",
				   "resizable=no,menubar=no,status=no,titlebar=yes,	      scrollbars=no,location=no,toolbar=no,height=247,width=250");
				formName.action="/reqsubmit/80_bindreqlist/addBinder.jsp";
				formName.target="addBind";
				formName.submit();
				//if (closetime)
				//  setTimeout("addBind.close();", closetime*1000);
		 }
   }

  /** 요구목록 체크박스에서 요구가 선택되었는지 여부 확인 */
  function hashCheckedReqInfoIDs(formName){
	var blnFlag=false;
  	if(formName.ReqInfoIDs.length==undefined){
  	  if(formName.ReqInfoIDs.checked==true){
		  alert("formName.ReqInfoIDs.length 는 하나이다");
  	  	blnFlag=true;
  	  }
  	}else{
  	  var intLen=formName.ReqInfoIDs.length;
  	  for(var i=0;i<intLen;i++){
  	    if(formName.ReqInfoIDs[i].checked==true){
  	      blnFlag=true;break;
  	    }
  	  }
  	}
  	if(blnFlag==false){
  		alert(" 선택하신 요구정보가 없습니다 \n하나 이상의 요구정보를 선택해 주세요");
  		return false;
  	}
  	return true;
  }


  /** 요구목록 체크박스에서 요구가 선택되었는지 여부 확인 */
  function hashCheckedGovReqInfoIDs(formName){
	var blnFlag=false;
  	if(formName.BindingReqBoxID.length==undefined){
  	  if(formName.BindingReqBoxID.checked==true){
		  alert("formName.ReqInfoIDs.length 는 하나이다");
  	  	blnFlag=true;
  	  }
  	}else{
  	  var intLen=formName.BindingReqBoxID.length;
  	  for(var i=0;i<intLen;i++){
  	    if(formName.BindingReqBoxID[i].checked==true){
  	      blnFlag=true;break;
  	    }
  	  }
  	}
  	if(blnFlag==false){
  		alert(" 선택하신 요구정보가 없습니다 \n하나 이상의 요구정보를 선택해 주세요");
  		return false;
  	}
  	return true;
  }

  function ReqGovConnectListData(formName){
	    var varAction = formName.action;
		var linkPath = "/reqsubmit/80_bindreqlist/ReqBoxLegiSysConnectList.jsp"
		formName.action=linkPath;
		formName.submit();
		formName.action = varAction;
}



   /**국정감사시스템 연계 바인딩 작업 (Background job)**/
   function ReqGovConnectList(formName,ReqBoxID){
		var varAction = formName.action;
		BindingProc=window.open("about:blank","BindingProc","resizable=yes,menubar=NO,status=NO,titlebar=NO,scrollbars=no,location=no,toolbar=NO,height=187,width=250" );
		//BindingProc=window.open("about:blank","BindingProc","resizable=YES,menubar=YES,status=YES,titlebar=YES,scrollbars=YES,location=YES,toolbarYESNO,height=300,width=400" );

		formName.action="/reqsubmit/80_bindreqlist/BindingProc.jsp?ReqBoxID=" + ReqBoxID ;
		formName.target="BindingProc";
		formName.submit();
		formName.action = varAction;
   }

   /** 제출자인경우 바인딩작업 sync job처리후 화면에서 보여준다. **/
     function submtBindingJob(formName,ReqBoxID){

		var varAction = formName.action;
		//alert(ReqBoxID);
		BindingProc=window.open("about:blank","BindingProc","resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=800,width=900" );
		//BindingProc=window.open("about:blank","BindingProc","resizable=YES,menubar=YES,status=YES,titlebar=YES,scrollbars=YES,location=YES,toolbarYESNO,height=300,width=400" );

		formName.action="/reqsubmit/80_bindreqlist/SubBindingJob.jsp?ReqBoxID=" + ReqBoxID ;
		formName.target="BindingProc";
		formName.submit();
		formName.action = varAction;
	}
/*
	요구서 미리 보기 추가
*/
     function PreReqDocView(formName,ReqBoxID){
		PreReqDocView=window.open("/reqsubmit/common/PreReqDocView.jsp?ReqBoxId=" + ReqBoxID,"PreReqDocView","resizable=yes,menubar=no,status=no,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=800,width=900" );
	}

/*
	답변서 미리 보기 추가
*/
	function PreAnsDocView(formName,ReqBoxID){
		PreAnsDocView=window.open("/reqsubmit/common/PreAnsDocView.jsp?ReqBoxId=" + ReqBoxID,"PreAnsDocView","resizable=yes,menubar=no,status=no,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=800,width=900" );

	}



</script>
</head>
<body leftmargin="0" topmargin="0">
	<form name="test" method="get"  action="./SGovSubDataBoxList.jsp">
		<input type=button onclick="openWin();" value="PDF문서 열기">
		<input type=button onclick="DLOrginalFile(test);" value="DOC 원본문서 다운로드">
		<input type=button onclick="RAnsDocOpen();" value="답변서 보기">
		<input type=button onclick="ReqDocOpen();" value="요구서 보기">
		<input type=button onclick="addBinder(test);" value="바인더 추가">
		<input type=button onclick="bindList();" value="바인더 리스트">
		<input type=button onclick="GovSubmitList();" value="회의자료 등록함">
		<input type=button onclick="ReqGovConnectListData(test);" value="국감시스템 연계 바인딩된파일 리스트">
		<input type=button onclick="ReqGovConnectList(test,'0000000222');" value=" 국감시스템 연계 바인딩 추가 ">
		<input type=button onclick="submtBindingJob(test,'0000000222');" value="  제출자 바인딩 작업"> 0000016262
		<input type=button onclick="PreReqDocView(test,'0000016262');" value="  요구서 미리보기">
		<input type=button onclick="PreAnsDocView(test,'0000016262');" value="  답변서 미리보기">

		자료 리스트
		<table>
			<tr>
				<td>
					<input id="check"  type="checkbox" name="checkAll" onClick="checkAllOrNot(document.listqry);">
				</td>
				<td width="13" height="22">NO</td>
			</tr>
			<tr>
				<tr height="22">
					<td align="center"><input  name="ReqInfoIDs" type="checkbox"  value ="0000000873">					ddddddd</td>

				</tr>
    	    </tr>
			<tr class="tbl-line">
                      		<td height="1" colspan="10"></td>
             </tr>
			 <tr>
				<tr height="22">
					<td align="center"><input  name="ReqInfoIDs" type="checkbox"  value ="0000000903">cccccccc</td>

				</tr>
    	    </tr>
			<tr class="tbl-line">
                    <td height="1" colspan="10"></td>
             </tr>
			 <tr class="tbl-line">
                      		<td height="1" colspan="10"></td>
             </tr>
			 <tr>
				<tr height="22">
					<td align="center"><input  name="ReqInfoIDs" type="checkbox"  value ="0000000347">cccccccc</td>

				</tr>
    	    </tr>
			<tr class="tbl-line">
                    <td height="1" colspan="10"></td>
             </tr>
		</table>
	</form>
   <form name="test22" method="get"  action="./BindingProc.jsp">
		<input type=button onclick="openWin();" value="PDF문서 열기">
		<input type=button onclick="DLOrginalFile(test22);" value="DOC 원본문서 다운로드">
		<input type=button onclick="RAnsDocOpen();" value="답변서 보기">
		<input type=button onclick="ReqDocOpen();" value="요구서 보기">
		<input type=button onclick="addBinder(test22);" value="바인더 추가">
		<input type=button onclick="bindList();" value="바인더 리스트">
		<input type=button onclick="GovSubmitList();" value="정부제출 자료함">

		<!--<input type="hidden" name="strGovSubmtYear" value="0000000072">-->
		<table>
			<tr>
				<td>
					<input id="check"  type="checkbox" name="checkAll" onClick="checkAllOrNot(document.listqry);">
				</td>
				<td width="13" height="22">NO</td>
			</tr>
			<tr>
				<tr height="22">
					<td align="center"><input  name="BindingReqBoxID" type="checkbox"  value ="0000000072">	일반요구함 정부제출자료 연계 1</td>

				</tr>
    	    </tr>
			<tr class="tbl-line">
                      		<td height="1" colspan="10"></td>
             </tr>
			 <tr>
				<tr height="22">
					<td align="center"><input  name="BindingReqBoxID" type="checkbox"  value ="0000000073">일반요구함 정부제출자료 연계 2</td>

				</tr>
    	    </tr>
			<tr class="tbl-line">
                    <td height="1" colspan="10"></td>
             </tr>
			 <tr class="tbl-line">
                      		<td height="1" colspan="10"></td>
             </tr>
			 <tr>
				<tr height="22">
					<td align="center"><input  name="BindingReqBoxID" type="checkbox"  value ="0000000074">일반요구함 정부제출자료 연계 3</td>

				</tr>
    	    </tr>
			<tr class="tbl-line">
                    <td height="1" colspan="10"></td>
             </tr>
		</table>
	</form>

</body>
</html>