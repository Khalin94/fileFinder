<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.bf.db.DBAccess" %>
<%@ page import="kr.co.kcc.bf.db.DBAccessException" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.addjob.AddJobDelegate" %>

<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%!
	public static String getSysDate(){
		String nowdate="";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		nowdate = sdf.format(new Date());
		return nowdate;
	}
%>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	System.out.println("==========================");
	System.out.println("요구함 작성 시작!!!");
	System.out.println("==========================");
	
	String strUserID   = objUserInfo.getUserID();
	String strOrganID  = objUserInfo.getOrganID();
	String strOrgnaNM  = "";
	String strUserNm = objUserInfo.getUserName();
	strUserNm = strUserNm.substring(0,2);

	// 2005-08-08 kogaeng ADD
	// 요구함의 종류에 따라서 입력정보와 전환될 URL이 달라야 한다.
	String strReqBoxTp = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxTp"), "001");
	String strReqScheID = StringUtil.getEmptyIfNull(request.getParameter("ReqScheID"));

	String strTitle = "요구함 작성";
	String strAction = "/reqsubmit/common/ReqInfoWriteAllInOneProc.jsp";
	if(CodeConstants.REQ_BOX_TP_CMT.equals(strReqBoxTp)) {
		strTitle = "위원회 요구함 작성";
		//strAction = "/reqsubmit/common/CmtReqInfoWriteAllInOneProc.jsp";
	}

	String CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("AllCmtOrganID"));
	String strSubmtDln = StringUtil.getEmptyIfNull((String)request.getParameter("SubmtDln"));
	String strNatCnt   = StringUtil.getEmptyIfNull(request.getParameter("NatCnt"));
	String strRltdDutyX = StringUtil.getEmptyIfNull(request.getParameter("RltdDutyX"));
	String[] SubSelectID = request.getParameterValues("SubSelectID");/**  선택된 제출기관 리스트  */
	/*
	int intArrLength = 0;
	if(SubSelectID != null) {
		intArrLength = SubSelectID.length;
	}

	String[] arrCmtSelectedID = new String[intArrLength];
	String[] arrSubmtSelectedID = new String[intArrLength];

	if(SubSelectID != null) {
		for(int i=0; i<intArrLength; i++) {
			String[] arrTmp = StringUtil.split("^", SubSelectID[i]);
			arrCmtSelectedID[i] = arrTmp[0];
			arrSubmtSelectedID[i] = arrTmp[1];
			out.println("Selected CMT Organ ID Value : " + arrCmtSelectedID[i]+", Selected Submit Organ ID Value : "+arrSubmtSelectedID[i]+"<BR>");
		}

		for(int i=0; i<arrCmtSelectedID.length; i++) {
			out.println("Selected CMT Organ ID Value : " + arrCmtSelectedID[i]+", Selected Submit Organ ID Value : "+arrSubmtSelectedID[i]+"<BR>");
		}
	}
	*/


	//겸직정보를 가져온다.

	ResultSetSingleHelper objRsSH=null;	/** 요구일정 정보 출력용  ResultSetSingleHelper*/
	ResultSetHelper objSubmtOrganRs=null;  /** 제출기관 리스트 출력용 ResultSetHelper */
	ResultSetHelper objRltdDutyRs=null;   /** 관련기관 리스트 출력용 RsHelper */
	ResultSetHelper objOrganRs = null;
	ResultSetHelper objSelectOrganRs = null;
	Hashtable objhashdata4 = null;
	String SessionNo2 = "";

	try {
	   	/********* 대리자 정보 설정 *********/
		CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate(); 		/**요구함 Delegate*/
	    ReqInfoAllInOneDelegate objReqAllOne = new ReqInfoAllInOneDelegate();
		OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */
//System.out.println("111111111111111111111111111111");
	    if(CmtOrganID.equals("")){
	   		/********* 값가져오기 **************/
	    	objOrganRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** 소속 위원회 */
	    	if(objOrganRs.next()) CmtOrganID=(String)objOrganRs.getObject("ORGAN_ID");
		}
//System.out.println("222222222222222222222222222222");
		objOrganRs=new ResultSetHelper(objReqAllOne.getReqOrganChart());   /** 전체 위원회 */
		strOrgnaNM = objReqAllOne.getOrganNM(strOrganID);

		objhashdata4 = (Hashtable)objReqAllOne.getSessionDBCode();
//System.out.println("3333333333333333333333333333333");
		String flagSession = (String)objhashdata4.get("USE_FLAG");
		String strCurDate = this.getSysDate();
		
//System.out.println("################## : strCurDate : "+strCurDate);
//System.out.println("################## : flagSession : "+flagSession);


		if(flagSession.equals("Y")){
			Hashtable hashdata = (Hashtable)objReqAllOne.getSessionNo(strCurDate);
//			if ( null == hashdata ) {
//				SessionNo2 = "333";
//			} else {
				SessionNo2 = (String)hashdata.get("SESSION");
//			}
//			System.out.println("1111" + SessionNo2);
		}else{
			Hashtable hashdata = (Hashtable)objReqAllOne.getSessionNoDSDM(strCurDate);
			SessionNo2 = (String)hashdata.get("SES_NUM");
//			System.out.println("2222" + SessionNo2);
			if(SessionNo2 == null){
				Hashtable hashdata2 = (Hashtable)objReqAllOne.getSessionNo(strCurDate);
				SessionNo2 = (String)hashdata2.get("SESSION");
//System.out.println("33333" + SessionNo2);
			}
		}
		
//System.out.println("44444444444444444444444444444444");
//System.out.println("ssss="+SessionNo2);
		/********* 값가져오기 **************/
		String FLAG = StringUtil.getEmptyIfNull(request.getParameter("FLAG"));
		objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(CmtOrganID));/**제출기관리스트*/
		if(FLAG.equals("sel")){
			if(SubSelectID != null) objSelectOrganRs =new ResultSetHelper(objOrganInfo.getSubmtOrganList2(SubSelectID));/** 선택된제출기관리스트*/
		}
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
	} catch(AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript" src="/js/forum.js"></script>

<script language="javascript">
    var singleSelect = true;
	var sortSelect = true;
	var sortPick = true;

	function initIt() {
		var SubOrganID = document.getElementById("SubOrganID");
		var selectOptions = SubOrganID.options;
		var selectIndex = SubOrganID.selectedIndex;
		var SubSelectID = document.getElementById("SubSelectID");
		var pickOptions = SubSelectID.options;
		pickOptions[0] = null;
		if (!(selectIndex > -1)) {
			selectOptions[0].selected = true;
			selectOptions[0].defaultSelected = true;
		}
		SubOrganID.focus();
	}
	function checkdata(){
		var SubOrganID = document.getElementById("SubOrganID");
		var selectedLength = SubOrganID.length;
		var selectOptions = SubOrganID.options;
		var SubSelectID = document.getElementById("SubSelectID");
		var pickOptions = SubSelectID.options;
		var pickOLength = pickOptions.length;
		for(var i = 0 ;i < pickOLength;i++ ){
			for(var j = 0; j < selectedLength;j++){
				if(selectOptions[j].selected == true){
					if(pickOptions[i].value == selectOptions[j].value){
					alert(pickOptions[i].text+"기관은 이미 선택하셨습니다.");
					selectOptions[j].selected = false;
					}
				}
			}
		}
	}
	function addIt() {
		checkdata();
		var SubOrganID = document.getElementById("SubOrganID");
		var selectIndex = SubOrganID.selectedIndex;
		var selectOptions = SubOrganID.options;
		var SubSelectID = document.getElementById("SubSelectID");
		var pickOptions = SubSelectID.options;
		var pickOLength = pickOptions.length;
		while (selectIndex > -1) {
			pickOptions[pickOLength] = new Option(SubOrganID[selectIndex].text);
			pickOptions[pickOLength].value = SubOrganID[selectIndex].value;
			if (singleSelect) {
				selectOptions[selectIndex] = null;
			}
			if (sortPick) {
				var tempText;
				var tempValue;
				while (pickOLength > 0 && pickOptions[pickOLength].value < pickOptions[pickOLength-1].value) {
					tempText = pickOptions[pickOLength-1].text;
					tempValue = pickOptions[pickOLength-1].value;
					pickOptions[pickOLength-1].text = pickOptions[pickOLength].text;
					pickOptions[pickOLength-1].value = pickOptions[pickOLength].value;
					pickOptions[pickOLength].text = tempText;
					pickOptions[pickOLength].value = tempValue;
					pickOLength = pickOLength - 1;
				}
			}
		selectIndex = SubOrganID.selectedIndex;
		pickOLength = pickOptions.length;
		}
		//selectOptions[0].selected = true;
	}

	function delIt() {
		var SubOrganID = document.getElementById("SubOrganID");
		var selectOptions = SubOrganID.options;
		var selectOLength = selectOptions.length;
		var SubSelectID = document.getElementById("SubSelectID");
		var pickIndex = SubSelectID.selectedIndex;
		var pickOptions = SubSelectID.options;
		while (pickIndex > -1) {
			if (singleSelect) {
				selectOptions[selectOLength] = new Option(SubSelectID[pickIndex].text);
				selectOptions[selectOLength].value = SubSelectID[pickIndex].value;
			}
			pickOptions[pickIndex] = null;
			if (singleSelect && sortSelect) {
				var tempText;
				var tempValue;
				while (selectOLength > 0 && selectOptions[selectOLength].value < selectOptions[selectOLength-1].value) {
					tempText = selectOptions[selectOLength-1].text;
					tempValue = selectOptions[selectOLength-1].value;
					selectOptions[selectOLength-1].text = selectOptions[selectOLength].text;
					selectOptions[selectOLength-1].value = selectOptions[selectOLength].value;
					selectOptions[selectOLength].text = tempText;
					selectOptions[selectOLength].value = tempValue;
					selectOLength = selectOLength - 1;
				}
			}
		pickIndex = SubSelectID.selectedIndex;
		selectOLength = selectOptions.length;
		}
	}

	function selIt(btn) {
		var SubSelectID = document.getElementById("SubSelectID");
		var pickOptions = SubSelectID.options;
		var pickOLength = pickOptions.length;
		if (pickOLength < 1) {
			alert("No Selections in the SubSelectID\nPlease Select using the [->] button");
			return false;
		}
		for (var i = 0; i < pickOLength; i++) {
			pickOptions[i].selected = true;
		}
		return true;
	}
	/*** 숫자만 입력받기.*/
	function CheckNumeric(field){
		var objEv = event.srcElement;
		var numPattern = /([^0-9])/;
		numPattern = objEv.value.match(numPattern);
		if(numPattern != null){
			alert("숫자만 입력해 주세요!");
			objEv.value="";
			objEv.focus();
			return;
		}
	}

	/*** 숫자만 입력받기.*/
	function CheckNumeric(){
		var objEv = event.srcElement;
		var numPattern = /([^0-9])/;
		numPattern = objEv.value.match(numPattern);
		if(numPattern != null){
			alert("숫자만 입력해 주세요!");
			objEv.value="";
			objEv.focus();
			return;
		}
	}

	function showPeriodDiv() {
		document.all.PeriodDIV.style.left = "400px";
		document.all.PeriodDIV.style.top = "108px";
		document.all.PeriodDIV.style.display = '';
		document.formName.AddDate.focus();
	}

	function hiddenPeriodDiv() {
		document.formName.AddDate.value = "";
		document.all.PeriodDIV.style.display = 'none';
	}

	function doSubmit() {
		var f = document.formName;
		if(f.AllCmtOrganID.value == "") {
			alert("위원회를 선택해 주세요.");
			f.CmtOrganID.focus();
			return;
		}
		if(f.NatCnt.value.length == 0) {
			alert("회기를 입력해 주세요. 단, 숫자만 입력해 주세요.");
			f.NatCnt.focus();
			return;
		}
		if(confirm("작성하신 요구서를 저장하시겠습니까?")) {
			opener.window.location.href='ReqBoxList2.html';
			self.close();
		}
	}

	function closeWindows() {
		if(confirm("현재 창을 닫게 되면 작업 중이던 모든 내용을 잃게 됩니다. 계속 진행하시겠습니까?")) {
			self.close();
		}
	}

	var numRef = 0;
	function AddReqInfoForm() {
		var str;
		if (numRef > 100) {
			alert("더이상 입력란을 추가하실 수 없습니다.");
		}else{

			str = "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"border:2px #CCC solid; \">";
			str = str + "<tr>";
			str = str + "<td bgcolor=\"#CCCCC\C\"><table width=\"100%\" border=\"0\" cellpadding=\"10\" cellspacing=\"1\">";
			str = str + "<tbody>";
			str = str + "<tr>";
			str = str + "<td width=\"30\" rowspan=\"3\" align=\"middle\" bgcolor=\"#CCCCCC\"><strong>"+(numRef+2)+"</strong></td>";
			str = str + "<td bgcolor=\"#f4f4f4\" width=\"60\" align=\"middle\">요구제목</td>";
			str = str + "<td height=\"25\" bgcolor=\"#FFFFFF\">&nbsp;";
			str = str + "<input onKeyDown=\"if(event.keyCode==13) event.keyCode=9;\" size=\"72\"";
			str = str + "name=\"ReqInfoTitle"+(numRef+1)+"\"  style=\"width:70%\"/>&nbsp;&nbsp;";
			str = str + "<input type=\"button\" value=\"삭제\" tabindex=\"-1\" onClick=\"DelReqInfoForm("+(numRef)+")\"";
			str = str + "style=\"height:21px\"></td>";
			str = str + "</tr>";
			str = str + "<tr>";
			str = str + "<td bgcolor=\"#f4f4f4\" align=\"middle\">요구내용</td>";
			str = str + "<td bgcolor=\"#FFFFFF\"><br />";
			str = str + "&nbsp;";
			str = str + "<textarea cols=\"72\" rows=\"6\" name=\"ReqInfoDesc"+(numRef+1)+"\"";
			str = str + " onKeyDown=\"javascript:updateChar(document.formName, 'ReqInfoDesc"+(numRef+1)+"', '2000', 'textlimit"+(numRef+1)+"')\" onKeyUp=\"javascript:updateChar(document.formName, 'ReqInfoDesc"+(numRef+1)+"', '2000', 'textlimit"+(numRef+1)+"')\" onFocus=\"javascript:updateChar(document.formName, 'ReqInfoDesc"+(numRef+1)+"', '2000', 'textlimit"+(numRef+1)+"')\" onClick=\"javascript:updateChar(document.formName, 'ReqInfoDesc"+(numRef+1)+"', '2000', 'textlimit"+(numRef+1)+"')\"";
			str = str + " style=\"width:90%;\"></textarea>";
			str = str + "<br />";
			str = str + "<br />";
			str = str + "<input type='text' name='textlimit"+(numRef+1)+"' size='4' style=\"border:0px solid #ffffff;";
			str = str + "font-family:verdana,돋움; font-size:11px;font-weight:bold;\">";
			str = str + "&nbsp;bytes (2000 bytes 까지만 입력됩니다) <br />";
			str = str + "<br /></td>";
			str = str + "</tr>";
			str = str + "<tr>";
			str = str + "<td bgcolor=\"#f4f4f4\" align=\"middle\">첨부파일</td>";
			str = str + "<td height=\"25\" bgcolor=\"#FFFFFF\">&nbsp;";
			str = str + "<input size=\"55\" type=\"file\" name=\"AnsEstyleFilePath"+(numRef+1)+"\"  style=\"width:90%;\"/></td>";
			str = str + "</tr>";
			str = str + "</tbody>";
			str = str + "</table></td>";
			str = str + "</tr>";
			str = str + "</table>";


			document.all.divReqInfo[numRef].innerHTML=str;
			var strtitle = eval("document.formName.ReqInfoTitle"+(numRef+1));
//			document.formName.submitbutton.focus();
//			strtitle.focus();
			numRef++;
		}

	}

	function DelReqInfoForm(num){
		document.all.divReqInfo[num].innerHTML="";
		numRef--;
	}
	function searchSubmit(){
		//var strOrganID = document.formName.CmtOrganID.value;
		//document.formName.target = "OrganFrame";
		//document.formName.action = "/reqsubmit/common/OrganSelect.jsp?CmtOrganID="+strOrganID;
		document.formName.FLAG.value="sel";
		for(var j=0;j<formName.SubSelectID.options.length;j++){
		   formName.SubSelectID.options[j].selected=true;
		   //alert(formName.SubSelectID.options[j].value);
		}
		document.formName.submit();
		//document.formName.target = "";
	}
	function selectAll() {
		var SubOrganID = document.getElementById("SubOrganID");
		var selectOptions = SubOrganID.options;
		var selectOLength = selectOptions.length;
		for(var i=0 ; i<selectOLength; i++){
			selectOptions[i].selected = true;
		}
	}
	var IsClick=false;
	var strPopup;
	var strGubun = -1;

	function ButtonProcessing()
	{
		try{
			if(strGubun < 0){

                /*

				var oPopup = window.createPopup();
				var  oPopBody  =  oPopup.document.body;
				oPopBody.style.backgroundColor  =  "white";
				oPopBody.style.border  =  "solid  #dddddd 1px";

				// "처리중입니다"라는 메시지와 로딩이미지가 표시되도록 한다.



				var leftX = document.body.clientWidth/2 -130;
				var topY = (document.body.clientHeight/1.7) - (oPopBody.offsetHeight/2);

				oPopup.show(leftX,  topY,  270,  130,  document.body);


				// createPopup()를 이용해 팝업페이지를 만드는 경우
				// 기본적으로 해당 팝업에서 onblur이벤트가 발생하면 그 팝업페이지는 닫히게 됩니다.

				// 해당 팝업페이지에서 onblur이벤트가 발생할때마다  메소드를 재호출하여

				// 팝업페이지가 항상 표시되게 합니다.
				oPopBody.attachEvent("onblur", ButtonProcessing);
				strPopup = oPopup;
				

				*/
                
				// 20180823 추가
                // loading_layer 생성
                var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
				$('body').prepend(innHtml);

				// loading_layer 제거
				//$('#loading_layer').remove();  

			}
			strGubun = -1;
		}
		catch(e) {}
	} 

	function notProcessing(){
		if(strPopup.isOpen){
			strPopup.hide();
			strGubun = 1;
		}
		IsClick = false;
		opener.location.reload();
	}

	function checkFormData(){
		if(!IsClick){
			var alertStr = "";
			if(formName.elements['NatCnt'].value==""){
				alertStr = alertStr + "- 회기\n";
			}
			if(formName.elements['SubmtDln'].value==""){
				alertStr = alertStr + "- 제출기한\n";
			}

			if (alertStr.length != 0) {
				alertStr = "[아래의 항목은 필수입력 항목입니다. 확인 바랍니다]\n\n" + alertStr;
				alert(alertStr);
				return;
			}

			if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
				alert("제출기한은 오늘(<%=StringUtil.getSysDate()%>)이후의 날짜를 선택하셔야합니다");
				formName.elements['SubmtDln'].focus();
				return false;
			}
			if(formName.elements['SubmtDln'].value <="<%=StringUtil.getSysDate()%>"){
				alert("제출기한은 접수기간 이후의 날짜를 선택하셔야합니다.");
				formName.elements['SubmtDln'].focus();
				return false;
			}

			if(formName.elements['req_box_nm'].value==""){
				alert("요구함명을 입력하여 주십시오.");
				return;
			}

			if(formName.elements['RltdDutyX'].value == ""){
				alert("업무구분을 선택하여 주십시오.");
				return;
			}

			var strValue = "";
			var strValue1 = "";
			for(var j=0;j<formName.SubSelectID.options.length;j++){
				   if(j == formName.SubSelectID.options.length-1){
						strValue = strValue+formName.SubSelectID.options[j].value;
						strValue1 = strValue1+formName.SubSelectID.options[j].text;
				   }else{
						strValue = strValue+formName.SubSelectID.options[j].value+",";
						strValue1 = strValue1+formName.SubSelectID.options[j].text+",";
				   }

			}
			if(strValue == ""){
				alert("제출기관을 선택하여 주십시오.");
				return;
			}

			formName.ContentCount.value = numRef+1;
			var strTitle = "";
			var strContent = "";
			var strFileExp = "";
			for(var j = 0 ; j < formName.ContentCount.value ; j++){
				tempTitle = eval("formName.ReqInfoTitle"+j);
				tempContent = eval("formName.ReqInfoDesc"+j);
				tempContLength = eval("formName.textlimit"+j);
				tempFilePath = eval("document.formName.AnsEstyleFilePath"+j+".value");
				//var tempFilePathExp = tempFilePath.split(".");

				if(tempTitle.value == ""){
					alert((j+1)+"번째 요구제목을 작성해 주십시오.");
					return;
				}
				if(tempContent.value == ""){
					alert((j+1)+"번째 요구내용을 작성해 주십시오.");
					return;
				}

				if(getByteLength(tempTitle.value) > 1000) {
					alert((j+1)+"번째 요구 제목이 제한 입력 양을 초과했습니다.\n\r요구 제목은 한글 500 자 (1000bytes) 이상을 입력하실 수 없습니다.");
					return;
				}

				if(tempContLength > 2000) {
					alert((j+1)+"번째 요구 내용이 제한 입력 양을 초과했습니다.\n\r요구 내용은 한글 1000 자 (2000bytes) 이상을 입력하실 수 없습니다.");
					return;
				}

				if (tempFilePath != "") {
					 if(fnBoardLimitAttach(tempFilePath)== false){
						return false;
					}
				}

				if (tempFilePath != "") {
					 if(fnBoardLimitAttach2(tempFilePath)== false){
						return false;
					}
				}

				if(j == formName.ContentCount.value-1){
					strTitle = strTitle + tempTitle.value;
					strContent = strContent + tempContent.value;
				}else{
					strTitle = strTitle + tempTitle.value+"Ω";
					strContent = strContent + tempContent.value+"Ω";
				}
			}
			//공개비공개 테스트
			var openCode;			
			var obj = null;			
			var find = false;
			var form = document.formName;
			obj = form.OpenCL;
			var size = obj.length;
			if(obj[0]) {
				for ( var i = 0; i < size; i++) {
					if (obj[i].checked == true) { // 만약 채크되어있는 라디오 버튼을 찾았을 경우
						openCode = obj[i].value;
					    //alert('kangthis logs => ' + openCode);
						find = true; // *구분을 찾았다는걸로(true)로 변환
						break; // *for문을 빠져나온다.
					} // end if
				} // end for
			} else {
				if (obj.checked == true) { // 만약 채크되어있는 라디오 버튼을 찾았을 경우				
					openCode = obj.value;
					//alert('kangthis logs => ' + openCode);
					find = true; // *구분을 찾았다는걸로(true)로 변환
					//break; // *for문을 빠져나온다.
				} // end if
			}
			if (find == false) { // 라디오버튼을 못찾았을 경우 메세지 띄우고 종료
				alert("공개 비공개를 선택해주세요.");
				obj[0].focus();
				return;
			}
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}




		if(confirm("요구함을 등록하시겠습니까?")){
			IsClick = true;  //버튼 처리를 수행중..
			//ButtonProcessing();  //처리상태를 표시하는 메소드 호출
			
			// hgyoo 20180823 추가
              // loading_layer 생성
            var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);
			
			formName.TempTitle.value = strTitle;
			formName.TempContent.value = strContent;
			formName.SubmtOrganID.value = strValue;
			formName.SubmtOrganNM.value = strValue1;
			//공개비공개 테스트
			formName.OpenCL.value = openCode;
			formName.encoding="multipart/form-data";
			formName.action = "<%= strAction %>";
			formName.target = 'processingFrame';
			formName.submit();
		}else{
			return false;
		}
  }//endfunc
  
  
  function pageBack() {
	  window.opener.location.href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp";  
  }
  

  

</script>

<script language='javascript'>

function noEvent() {
    if (event.keyCode == 116) {
        event.keyCode= 2;
        return false;
    }
    else if(event.ctrlKey && (event.keyCode==78 || event.keyCode ==
82))
    {
        return false;
    }
}
document.onkeydown = noEvent;

</script>


</head>

<body oncontextmenu="return false">
<iframe name='processingFrame' height='0' width='0'></iframe>
<FORM method="post" name="formName" action="<%=request.getRequestURI()%>">
<div class="reqBox">
    <p><%= strTitle %></p>
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">
<input type="hidden" name="AuditYear" value="">
<input type="hidden" name="ReqScheID" value="<%= strReqScheID %>">
<input type="hidden" name="IngStt" value="003">
<input type="hidden" name="SubmtOrganID">
<input type="hidden" name="SubmtOrganNM">
<input type="hidden" name="ContentCount">
<input type="hidden" name="TempTitle">
<input type="hidden" name="TempContent">
<input type="hidden" name="FLAG" value="">
<input type="hidden" name="ReqBoxTp" value="<%= strReqBoxTp %>">
<input type="hidden" name="openCode">

                <!-------------------- TABLE START-------------------------------->

                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;<strong>요구기관   : </strong></th>
                        <td colspan="3"><span class="point"><%= strOrgnaNM %></span></td>
                    </tr>
                     <tr>
                        <th align="left" scope="col"><strong>&bull;&nbsp;회기 : </strong></th>
                        <td colspan="3">제
                            <input onKeyUp="CheckNumeric()" value="<%=SessionNo2%>" maxlength="3" size="3" name="NatCnt" />
회 국회 </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col"><strong>&bull;&nbsp;업무구분 : </strong></th>
                        <td><select name="RltdDutyX">
                            <option selected="selected" value="">선택</option>
                            <option value="001" <%if(strRltdDutyX.equals("001")){%>selected<%}%>>국정감사</option>
							<option value="002" <%if(strRltdDutyX.equals("002")){%>selected<%}%>>국정조사</option>
							<option value="004" <%if(strRltdDutyX.equals("004")){%>selected<%}%>>결산</option>
							<option value="005" <%if(strRltdDutyX.equals("005")){%>selected<%}%>>기금</option>
							<option value="006" <%if(strRltdDutyX.equals("006")){%>selected<%}%>>법안</option>
							<option value="003" <%if(strRltdDutyX.equals("003")){%>selected<%}%>>예산안</option>
							<option value="007" <%if(strRltdDutyX.equals("007")){%>selected<%}%>>기타(임시회 등)</option>
                        </select></td>
                        <th scope="col"><strong>&bull;&nbsp;</strong>제출기한</th>
                        <td><input onKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" onClick="this.select()" readonly="readonly" maxlength="8" size="10" name="SubmtDln" value="<%=strSubmtDln%>"/>
                        <a href="#"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  OnClick="javascript:show_calendar('formName.SubmtDln');"/></a></td>
                    </tr>
                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;소관위원회</th>
                        <td colspan="3">
						<%
							if(CodeConstants.REQ_BOX_TP_CMT.equals(strReqBoxTp)) {
								out.println("<input type='hidden' name='AllCmtOrganID' value='"+CmtOrganID+"'>");
								out.println(strOrgnaNM);
							} else {
						%>
							<select name="AllCmtOrganID" onChange="searchSubmit()">
								<%while(objOrganRs.next()){
									if(!strUserNm.equals("교육")&&!strUserNm.equals("관리")){
										if(!(objOrganRs.getObject("ORGAN_ID")).equals("GI00006426")){
								%>
								<option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(CmtOrganID.equals(objOrganRs.getObject("ORGAN_ID"))){%> selected <%}%>>
								<%=objOrganRs.getObject("ORGAN_NM")%></option>
								<%
										}
									}else{
									%>
									<option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(CmtOrganID.equals(objOrganRs.getObject("ORGAN_ID"))){%> selected <%}%>>
									<%=objOrganRs.getObject("ORGAN_NM")%></option>
								<%
								}}%>
							</select>
							<%
								}
							%>
						</td>
                    </tr>
                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;<strong>요구함명   : </strong></th>
                        <td colspan="3"><input size="66" name="req_box_nm" style="width:350px;" /></td>
                    </tr>
                </table>
<br />

                <!--   				### Sample ###  				<iframe frameborder="0" height="300" marginheight="0" marginwidth="0" scrolling="no"   				src="./notice.cgi" width="100%" topmargin="0"></iframe>  				-->

                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top" ><table width="100%" border="0" cellpadding="10" cellspacing="0" >
                                <tr>
                                    <td width="190" height="25" align="center" bgcolor="#00CC33" style="color:#FFF" ><strong>제출기관</strong></td>
                                    <td  align="center" bgcolor="#339933"  style="color:#FFF"><strong>요구 목록</strong></td>
                                </tr>
                                <tr>
                                    <td  valign="top" style="padding:10px ; border-right: #CCC solid 1px"><table width="100%" border="0" cellspacing="5" cellpadding="0">
                                            <tr>
                                                <td height="25"><!---------------------------- START ------------------------------>
                                                    <!--  							<iframe src="OrganSelect.jsp" id="OrganFrame" name="OrganFrame" frameBorder="0"   							height="80" marginheight="0" marginwidth="0" scrolling="auto" width="100%" topmargin="0"></iframe>  							-->
                                                    <span class="list01_tl">제출기관 목록 </span></td>
                                            </tr>
                                            <tr>
                                                <td>
													<select name="SubOrganID" ID="SubOrganID" size="10" multiple="multiple" style="width:180px">
														<%if(objSubmtOrganRs != null){%>
															<%while(objSubmtOrganRs.next()){%>
																<option value="<%=objSubmtOrganRs.getObject("CMT_ORGAN_ID")%>^<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_ID")%>">
																<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_NM")%></option>
															<%}%>
														<%}%>
													</select>
												</td>
                                            </tr>
                                            <tr>
                                                <td height="35"><!-- 리스트 버튼-->
                                                    <div id="btn_all" >
														<span class="list_bts"><a href="#" onClick="javascript:selectAll()">전체선택</a></span>
														<span class="list_bts"><a href="#" onClick="javascript:addIt()">추가</a></span>
														<span class="list_bts"><a href="#" onClick="javascript:delIt()">삭제</a></span>
													</div>

                                                    <!-- /리스트 버튼-->
												</td>
                                            </tr>
                                            <tr>
                                                <td height="25"><span class="list01_tl">선택된 제출기관 목록 </span></td>
                                            </tr>
                                            <tr>
                                                <td><!--&nbsp;&nbsp; <input type="button" value="모두 선택" class="button" onClick="selectSubmit()">-->

                                                    <select id="SubSelectID" multiple="multiple" size="10" name="SubSelectID" style="width:220px;">
													<%while(objSelectOrganRs!=null && objSelectOrganRs.next()){%>
														<option value="<%=objSelectOrganRs.getObject("CMT_ORGAN_ID")%>^<%=objSelectOrganRs.getObject("ORGAN_ID")%>">
														<%=objSelectOrganRs.getObject("ORGAN_NM")%></option>
													<%}%>
                                                    </select>

                                                    <!--  							<iframe src="SubmitOrganSelect.jsp" id="SubmitOrganFrame" name="SubmitOrganFrame" frameBorder="0" height="300" marginheight="0" marginwidth="0" scrolling="auto" width="100%" topmargin="0"></iframe>  							--></td>
                                            </tr>
                                        </table>
										</td>
	                                    <td valign="top" style="padding:10px">
											<table width="100%" border="0" cellspacing="0" cellpadding="0" style=" border:2px #CCC solid; ">
                                            <tr>
                                                <td bgcolor="#CCCCCC"><table width="100%" border="0" cellpadding="10" cellspacing="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30" rowspan="3" align="middle" bgcolor="#CCCCCC"><strong>1</strong></td>
                                                                <td bgcolor="#f4f4f4" width="60" align="middle">요구제목</td>
                                                                <td height="25" bgcolor="#FFFFFF">&nbsp;
                                                                    <input onKeyDown="if(event.keyCode==13) event.keyCode=9;" size="72" name="ReqInfoTitle0"  style="width:90%"/></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f4f4f4" align="middle">요구내용</td>
                                                                <td bgcolor="#FFFFFF"><br />
                                                                    &nbsp;
                                                                    <textarea
																	name="ReqInfoDesc0" onKeyDown="javascript:updateChar(document.formName, 'ReqInfoDesc0', '2000', 'textlimit0')"
																	onKeyUp="javascript:updateChar(document.formName, 'ReqInfoDesc0', '2000', 'textlimit0')"
																	onFocus="javascript:updateChar(document.formName, 'ReqInfoDesc0', '2000', 'textlimit0')"
																	onClick="javascript:updateChar(document.formName, 'ReqInfoDesc0', '2000', 'textlimit0')" rows="6" cols="72" name="ReqInfoDesc0" style="width:90%;"></textarea>
                                                                    <table border="0" cellpadding="0" cellspacing="0"><tr><td width="400" style="padding-left:5px">
																	<input type="text" name="textlimit0" size="4" style="border:0px solid #ffffff; font-family:verdana,돋움; font-size:11px;font-weight:bold;" align="right"> bytes (2000 bytes 까지만 입력됩니다)
																	</td></tr></table>
																</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#f4f4f4" align="middle">첨부파일</td>
                                                                <td height="25" bgcolor="#FFFFFF">&nbsp;
                                                                    <input size="55" type="file" name="AnsEstyleFilePath0"  style="width:90%;"/></td>
                                                            </tr>
                                                        </tbody>
                                                    </table></td>
                                            </tr>
                                        </table>
                                        <span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><span id="divReqInfo"></span><br />
                                        <span class="warning">* 요구제목은 한글 500자   이내, 요구 내용은 한글 1000자 까지 입력 가능합니다. </span>

										<span class="list_bts right">
										<!--
										<a href="#" onClick="AddReqInfoForm()">요구추가</a></span>
										-->
										<input name="submitbutton" type="button" value="요구 추가" class="button" onClick="AddReqInfoForm()" style="height:23px">

										</td>
                                </tr>

                                <!--  					<tr>                         <td height="25" bgcolor="#f4f4f4" align="center">제출양식샘플</td>  					  <td width="1" bgcolor="#c0c0c0"></td>                        <td height="25" align="center" colspan="3">	                        	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">  					  </td>                      </tr>  					<tr>  						<td height="1" bgcolor="#c0c0c0" colspan="3"></td>  					</tr>  					-->
                                <tr>
                                    <td height="25" colspan="4" align="center" bgcolor="#66CC66" style="  color:#FFF" ><strong>공개설정</strong></td>
                                </tr>
                                <tr>
                                    <td height="30" align="middle">
                                        <input value="001" type="radio" name="OpenCL" style="border:none;" />
                                        공개
                                        &nbsp;&nbsp;&nbsp;
                                        <input value="002" checked="checked" type="radio" name="OpenCL"  style="border:none;"/>
                                        비공개  </td>
                                    <td colspan="3" align="left"><span class="warning">* 요구 내용을 타 의원실에 공개할지 여부를 지정하는   기능입니다</span></td>
                                </tr>
                            </table>
                    </tr>
                </table>

                <!------------------------------------- TABLE END -----------------------------------------></td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <!-- 리스트 버튼-->
    <div id="btn_all"  class="t_right">    
    	<span class="list_bt"><a href="#" onClick="checkFormData()">요구함저장</a>
    	</span> <span class="list_bt"><a href="#"  onClick="javascript:formName.reset()">초기화</a></span>
    	<span class="list_bt"><a href="#" onClick="closeWindows()">작성취소</a></span>
    	&nbsp;&nbsp;
   	</div>

    <!-- /리스트 버튼-->
</form>
</div>
</body>
</html>
