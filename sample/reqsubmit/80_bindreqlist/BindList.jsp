<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo = null;
 CDInfoDelegate objCdinfo =null;

%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

//이용자 정보 설정.
	ArrayList objAllBinderArray = null;
	Hashtable objBinderHash = null;
	ResultSetHelper objRs = null;

	String strReqId = null;
	String strBinderSortField = null;
	String strBinderSortMtd = null;
	String strCurrentPageNum = null;
	String strPageSize = null;

	boolean blnBindFileSessionExist = true ;
	int intPageSize = 10 ; //  보여줄수있는 페이지 수
	int	intTotalRecordCount = 0;
	int	intCurrentPageNum = 0;
	int	intTotalPage = 0;
	int	intRecordNumber = 0;
	int intIndexNum = 1;
	int intStartPage = 0;
	int intEndPage = 0;

	//정렬 정보 받기
	strBinderSortField = request.getParameter("binderSortField");
	//System.out.println("[BindList.jsp] strBinderSortField = " + strBinderSortField);
	if(strBinderSortField == "" || strBinderSortField.equals("")){
		strBinderSortField = "ANS_DT";
	}
 	strBinderSortMtd= request.getParameter("binderSortMtd");
 	if(strBinderSortMtd == "" || strBinderSortMtd.equals("")){
		strBinderSortMtd = "DESC";
	}
	//System.out.println("[BindList.jsp] strBinderSortMtd = " + strBinderSortMtd);

	// 정보 페이지 번호 받기
	strCurrentPageNum = request.getParameter("binderPageNum");
	if( strCurrentPageNum == "" || strCurrentPageNum.equals("")){
		strCurrentPageNum = "1";
	}

	Integer objIntD = new Integer(strCurrentPageNum);
	intCurrentPageNum = objIntD.intValue();
	//System.out.println("[BindList.jsp] intCurrentPageNum = " + intCurrentPageNum);

	bindDelegate objBindDelegate = new bindDelegate();

	objAllBinderArray = (ArrayList)session.getAttribute(EnvConstants.BINDER);

    if(objAllBinderArray == null || objAllBinderArray.equals("")){
       //System.out.println("[BindList.jsp] 세션에 값이 없다." );
       blnBindFileSessionExist = false ;
    }else{
	   int intCnt = objAllBinderArray.size();
	   if(intCnt == 0){
			blnBindFileSessionExist = false ;
	   }else{
		    //System.out.println("[BindList.jsp] 세션에 값이 몇개 ? " + intCnt);
			//intCurrentPageNum = 1
			intRecordNumber= (intCurrentPageNum -1) * intPageSize +1;
			intStartPage = intRecordNumber;
			intEndPage = intCurrentPageNum*10;
			//System.out.println("intStartPage =" + intStartPage + "\nintEndPage =" + intEndPage + "\nintRecordNumber = " + intRecordNumber);
	        objBinderHash =
	objBindDelegate.getBindList("ANS_ID",strBinderSortMtd,strBinderSortField,objAllBinderArray,intCurrentPageNum,intPageSize);	//objBindDelegate.getBindList("ANS_ID",strBinderSortMtd,strBinderSortField,objAllBinderArray,intStartPage,intEndPage);

			/*
			for (java.util.Enumeration enum=objBinderHash.keys();enum.hasMoreElements();){
				//System.out.println("Key:" + (String)enum.nextElement());
			}
			*/

			objRs=new ResultSetHelper(objBinderHash);

			intCurrentPageNum = objRs.getPageNumber();//현재페이지번호
			intTotalRecordCount = objRs.getTotalRecordCount();//전체 조회된 레코드갯수
			intRecordNumber = objRs.getRecordSize(); //출력할 레코드개수
			intTotalPage = objRs.getTotalPageCount();//페이지개수
			strPageSize = Integer.toString(intPageSize);
	   }
    }

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
 var blnCheckBoxFlag=false;
  function checkAllOrNot(formName){
   var i, chked=0, k=0;
   	  blnCheckBoxFlag=!blnCheckBoxFlag;
	  for(i=0;i<formName.length;i++){
	   if(formName[i].type=='checkbox'){
		//if(document.formName[i].checked){formName[i].checked=false;} else{formName[i].checked=true;}
		  formName[i].checked=blnCheckBoxFlag;
		  formName.checkAll.checked=blnCheckBoxFlag;
	   }
	}
	return true;
  }//end func



  function changeSortQuery(sortField,sortMethod){
  	listqry.binderSortField.value=sortField;
  	listqry.binderSortMtd.value=sortMethod;
  	listqry.submit();
  }

  function goPage(strPage){
  	listqry.binderPageNum.value=strPage;
  	listqry.submit();
  }


  function gotoDelete(sortField,sortMethod,intCurrentPageNum,intCount){
	  //disabled
		var blnCheck = false;
		if(intCount == 2){
			if(document.listqry.Del.checked == 1){
				blnCheck = true;
			}else{
				blnCheck = false
			}
		}else{
			for(var i = 0 ; i < intCount-1 ; i++){
				if(document.listqry.Del[i].checked == 1	){
					blnCheck = true;
					break;
				}else{
					blnCheck = false
				}
			}
		}

	if(blnCheck){
	  if(confirm("바인더 목록에서 삭제하시겠습니까 ?")==true){
		listqry.method="post";
		listqry.action="/reqsubmit/80_bindreqlist/DeleteBinder.jsp";
		listqry.binderSortField.value=sortField;
	  	listqry.binderSortMtd.value=sortMethod;
		listqry.binderPageNum.value=intCurrentPageNum;
		listqry.submit();
	  }
	}else{
		alert("삭제할 목록을 선택하세요");
	}

  }

  function gotoBindProc(formName,binderListSize){

		if(binderListSize == 0){
			alert("바인딩 목록이 추가된 자료가 없습니다. 바인딩할 목록을 추가해 주세요");
		}else if(binderListSize-1 == 1){
			alert("바인딩 목록이 두개 이상이어야 합니다. 바인딩할 목록을 추가해 주세요");
		}else{

			var varTarget = formName.target;
			var varAction = formName.action;

			var winl = (screen.width - 900) / 2;
			var wint = (screen.height - 800) / 2;
			winpose = 'height=800,width=900'+',top='+wint+',left='+winl+', resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no';

	         //PreReqDocViewda = window.open("/blank.html","PreAnsDocView",winpose);
	         BindProc = window.open("/blank.html","BindProc",winpose);
	         formName.action="/reqsubmit/80_bindreqlist/BindProc.jsp";
			 formName.target="BindProc";
			 formName.submit();
			 formName.target = varTarget;
			 formName.action = varAction;

		     if(parseInt(navigator.appVersion) >= 4) BindProc.window.focus();

				/*
				var varTarget = formName.target;
				var varAction = formName.action;
				BindProc = window.open("/blank.html","BindProc","resizable=YES,menubar=no,status=no,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=650,width=800");
				formName.action="/reqsubmit/80_bindreqlist/BindProc.jsp";
				formName.target="BindProc";
				formName.submit();
				formName.target = varTarget;
				formName.action = varAction;
				*/
		}
 }

   function PdfFileOpen(formName,strHttp,ansId){

       /* var httpAddress = strHttp + ansId + "&DOC=PDF";

		var varTarget = formName.target;
		var varAction = formName.action;

		PdfView = window.open("about:blank","PdfView","resizable=YES,menubar=no,status=yes,titlebar=no,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
		formName.action= httpAddress;
		formName.target="PdfView";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
   */
  		var httpAddress = strHttp + ansId + "&DOC=PDF";
		window.open(httpAddress,"PdfView","resizable=YES,menubar=no,status=yes,titlebar=no,scrollbars=no,location=no,toolbar=no,height=600,width=800" );

   }

   function  gotoNotBindProc(){
		alert("바인딩할 요구목록이 존재하지 않습니다. 바인더 목록에 요구를 등록하십시요.");
   }

   function  gotoNotDelete(){
		alert("바인딩할 요구목록이 존재하지 않습니다. 요구를 삭제 할수 없습니다.");
   }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
   <form name="listqry" method="get" action="<%=request.getRequestURI()%>">
					<input type="hidden" name="binderSortField" value="<%=strBinderSortField%>"><!--요구함목록정렬필드 -->
					<input type="hidden" name="binderSortMtd" value="<%=strBinderSortMtd%>"><!--요구함목록정령방법-->
					<input type="hidden" name="binderPageNum" value="<%=intCurrentPageNum%>"><!--페이지 번호 -->

      <!-- pgTit -->
<%
	  String strTitle1 = MenuConstants.BINDER_LIST ;
	  String strLocation2 =  MenuConstants.GOTO_HOME + " > " + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > "  + 	MenuConstants.BINDER_LIST;

%>

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=strTitle1%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /><%=strLocation2%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p>선택된 요구 목록</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
				<input id="check" name="checkAll" type="checkbox" value="" class="borderNo" onClick="checkAllOrNot(document.listqry);"/>
			 </th>
              <th scope="col" style="width:15px;"><%=SortingUtil.getSortLink("changeSortQuery","",strBinderSortField,strBinderSortMtd,"NO")%></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strBinderSortField,strBinderSortMtd,"요구내용")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strBinderSortField,strBinderSortMtd,"요구함명")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM",strBinderSortField,strBinderSortMtd,"요구기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strBinderSortField,strBinderSortMtd,"제출기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strBinderSortField,strBinderSortMtd,"파일")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","ANS_DT",strBinderSortField,strBinderSortMtd,"답변일")%></a></th>
            </tr>
          </thead>
          <tbody>
		<%
		intIndexNum = intStartPage;
		if(blnBindFileSessionExist){

			 if(intRecordNumber > 0){
				String cmtOrganNm = null;
				String	reqOrganNm = null;

				while(objRs.next()){
					 cmtOrganNm  = (String)objRs.getObject("REQ_BOX_TP");
					 reqOrganNm = (String)objRs.getObject("REQ_ORGAN_NM");


					String strAnsDt = (String)objRs.getObject("ANS_DT");
					strAnsDt = StringUtil.getDate(strAnsDt);

					String strReqDt = (String)objRs.getObject("REG_DT");
					strReqDt = StringUtil.getDate(strReqDt);
		 %>
            <tr>
              <td ><input id="chk<%=intIndexNum%>" name="Del" type="checkbox" value ="<%=(String)objRs.getObject("ANS_ID")%>"  class="borderNo" /></td>
              <td><%= intIndexNum %></td>
              <td><%=objRs.getObject("REQ_CONT")%></td>
              <td><%=objRs.getObject("REQ_BOX_NM")%></td>
              <td><%=reqOrganNm%></td>
              <td><%=objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td>
				<a href="javascript:PdfFileOpen(listqry,'/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=','<%=(String)objRs.getObject("ANS_ID")%>');"><img src="/image/common/icon_pdf.gif" border="0"></a>
			  </td>
              <td><%=strAnsDt%></td>
            </tr>
				<%
						intIndexNum++;
					}//endwhile
				}else { //end	intRecordNumber < 0	다??
				%>
			<tr>
				<td colspan="8" align="center">선택된 바인더 요구 목록이 없습니다.</td>
			</tr>
				<%
				 }
				%>
			<%
			} else { // 바인더 목록정보가 없습니다.
			%>
			<tr height="22">
				<td colspan="8" align="center">선택된 바인더 요구 목록이 없습니다.</td>
			</tr>
		<%
			} //end blnBindFileSessionExist
		%>
          </tbody>
        </table>

        <!-- /list -->



        <!-- 페이징
                	<%= PageCount.getLinkedString(
										new Integer(intTotalRecordCount).toString(),
										new Integer(intCurrentPageNum).toString(),"10")
					%>-->
        <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->


			        <%=objPaging.pagingTrans(PageCount.getLinkedString(
										new Integer(intTotalRecordCount).toString(),
										new Integer(intCurrentPageNum).toString(),"10")) %>



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <!-- /리스트 내 검색 -->
		<span class="right">
			<span class="list_bt"><a href="javascript:gotoBindProc(listqry,'<%=intIndexNum%>')">바인딩</a></span>
			<span class="list_bt"><a href="javascript:gotoDelete('<%=strBinderSortField%>','<%=strBinderSortMtd%>','<%=intCurrentPageNum%>','<%=intIndexNum%>')">삭제</a></span>
		</span>
		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>