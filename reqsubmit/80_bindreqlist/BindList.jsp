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
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo = null;
 CDInfoDelegate objCdinfo =null;

%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

//�̿��� ���� ����.
	ArrayList objAllBinderArray = null;
	Hashtable objBinderHash = null;
	ResultSetHelper objRs = null;

	String strReqId = null;
	String strBinderSortField = null;
	String strBinderSortMtd = null;
	String strCurrentPageNum = null;
	String strPageSize = null;

	boolean blnBindFileSessionExist = true ;
	int intPageSize = 10 ; //  �����ټ��ִ� ������ ��
	int	intTotalRecordCount = 0;
	int	intCurrentPageNum = 0;
	int	intTotalPage = 0;
	int	intRecordNumber = 0;
	int intIndexNum = 1;
	int intStartPage = 0;
	int intEndPage = 0;

	//���� ���� �ޱ�
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

	// ���� ������ ��ȣ �ޱ�
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
       //System.out.println("[BindList.jsp] ���ǿ� ���� ����." );
       blnBindFileSessionExist = false ;
    }else{
	   int intCnt = objAllBinderArray.size();
	   if(intCnt == 0){
			blnBindFileSessionExist = false ;
	   }else{
		    //System.out.println("[BindList.jsp] ���ǿ� ���� � ? " + intCnt);
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

			intCurrentPageNum = objRs.getPageNumber();//������������ȣ
			intTotalRecordCount = objRs.getTotalRecordCount();//��ü ��ȸ�� ���ڵ尹��
			intRecordNumber = objRs.getRecordSize(); //����� ���ڵ尳��
			intTotalPage = objRs.getTotalPageCount();//����������
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
	  if(confirm("���δ� ��Ͽ��� �����Ͻðڽ��ϱ� ?")==true){
		listqry.method="post";
		listqry.action="/reqsubmit/80_bindreqlist/DeleteBinder.jsp";
		listqry.binderSortField.value=sortField;
	  	listqry.binderSortMtd.value=sortMethod;
		listqry.binderPageNum.value=intCurrentPageNum;
		listqry.submit();
	  }
	}else{
		alert("������ ����� �����ϼ���");
	}

  }

  function gotoBindProc(formName,binderListSize){

		if(binderListSize == 0){
			alert("���ε� ����� �߰��� �ڷᰡ �����ϴ�. ���ε��� ����� �߰��� �ּ���");
		}else if(binderListSize-1 == 1){
			alert("���ε� ����� �ΰ� �̻��̾�� �մϴ�. ���ε��� ����� �߰��� �ּ���");
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
		alert("���ε��� �䱸����� �������� �ʽ��ϴ�. ���δ� ��Ͽ� �䱸�� ����Ͻʽÿ�.");
   }

   function  gotoNotDelete(){
		alert("���ε��� �䱸����� �������� �ʽ��ϴ�. �䱸�� ���� �Ҽ� �����ϴ�.");
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
					<input type="hidden" name="binderSortField" value="<%=strBinderSortField%>"><!--�䱸�Ը�������ʵ� -->
					<input type="hidden" name="binderSortMtd" value="<%=strBinderSortMtd%>"><!--�䱸�Ը�����ɹ��-->
					<input type="hidden" name="binderPageNum" value="<%=intCurrentPageNum%>"><!--������ ��ȣ -->

      <!-- pgTit -->
<%
	  String strTitle1 = MenuConstants.BINDER_LIST ;
	  String strLocation2 =  MenuConstants.GOTO_HOME + " > " + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > "  + 	MenuConstants.BINDER_LIST;

%>

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=strTitle1%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /><%=strLocation2%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p>���õ� �䱸 ���</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
				<input id="check" name="checkAll" type="checkbox" value="" class="borderNo" onClick="checkAllOrNot(document.listqry);"/>
			 </th>
              <th scope="col" style="width:15px;"><%=SortingUtil.getSortLink("changeSortQuery","",strBinderSortField,strBinderSortMtd,"NO")%></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strBinderSortField,strBinderSortMtd,"�䱸����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strBinderSortField,strBinderSortMtd,"�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM",strBinderSortField,strBinderSortMtd,"�䱸���")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strBinderSortField,strBinderSortMtd,"������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strBinderSortField,strBinderSortMtd,"����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","ANS_DT",strBinderSortField,strBinderSortMtd,"�亯��")%></a></th>
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
				}else { //end	intRecordNumber < 0	��??
				%>
			<tr>
				<td colspan="8" align="center">���õ� ���δ� �䱸 ����� �����ϴ�.</td>
			</tr>
				<%
				 }
				%>
			<%
			} else { // ���δ� ��������� �����ϴ�.
			%>
			<tr height="22">
				<td colspan="8" align="center">���õ� ���δ� �䱸 ����� �����ϴ�.</td>
			</tr>
		<%
			} //end blnBindFileSessionExist
		%>
          </tbody>
        </table>

        <!-- /list -->



        <!-- ����¡
                	<%= PageCount.getLinkedString(
										new Integer(intTotalRecordCount).toString(),
										new Integer(intCurrentPageNum).toString(),"10")
					%>-->
        <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->


			        <%=objPaging.pagingTrans(PageCount.getLinkedString(
										new Integer(intTotalRecordCount).toString(),
										new Integer(intCurrentPageNum).toString(),"10")) %>



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <!-- /����Ʈ �� �˻� -->
		<span class="right">
			<span class="list_bt"><a href="javascript:gotoBindProc(listqry,'<%=intIndexNum%>')">���ε�</a></span>
			<span class="list_bt"><a href="javascript:gotoDelete('<%=strBinderSortField%>','<%=strBinderSortMtd%>','<%=intCurrentPageNum%>','<%=intIndexNum%>')">����</a></span>
		</span>
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>