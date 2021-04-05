<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
    /*** PagingDelegate */
    PagingDelegate objPaging=new PagingDelegate();         /*����¡ ��ȯ Delegate*/
%>
<%
    UserInfoDelegate objUserInfo =null;
    CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
    SMemReqBoxDelegate selfDelegate = null;
    MemRequestBoxDelegate reqDelegate = null;
    SMemReqInfoDelegate reqInfoDelegate = null;

    SMemReqBoxVListForm objParams = new SMemReqBoxVListForm();
    //SReqInfoListForm objParams = new SReqInfoListForm();
    // �䱸�� ������ ���θ� Form�� �߰��Ѵ�

      objParams.setParamValue("IsRequester", String.valueOf(objUserInfo.isRequester()));

    boolean blnParamCheck=false;
    blnParamCheck = objParams.validateParams(request);
    if(blnParamCheck==false) {
          objMsgBean.setMsgType(MessageBean.TYPE_WARN);
          objMsgBean.setStrCode("DSPARAM-0000");
          objMsgBean.setStrMsg(objParams.getStrErrors());
          out.println("ParamError:" + objParams.getStrErrors());
          return;
      }//endif

    // �Ѿ�� �Ķ���͸� �����ؼ� �ʿ��� ?? ������ ����
    // �䱸�� ����
    String strReqBoxID = objParams.getParamValue("ReqBoxID");
    String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
    String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
    String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
    String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
    String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");

    // �䱸 ��� ����
    String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
    String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
    String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
    String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
    String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");

    // �䱸 ���� �� ����¡ ����
    int intTotalRecordCount = 0;
    int intCurrentPageNum = 0;
    int intTotalPage = 0;

    ResultSetSingleHelper objRsSH = null;
    ResultSetHelper objRs = null;

    try{
        selfDelegate = new SMemReqBoxDelegate();
           reqDelegate = new MemRequestBoxDelegate();
           reqInfoDelegate = new SMemReqInfoDelegate();

           boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

           if(!blnHashAuth) {
               objMsgBean.setMsgType(MessageBean.TYPE_WARN);
                objMsgBean.setStrCode("DSAUTH-0001");
                objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
                out.println("�ش� �䱸���� �� ������ �����ϴ�.");
            return;
        } else {
            // �䱸�� ��� ������ SELECT �Ѵ�.
            objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID));
            // �䱸 ����� SELECT �Ѵ�.
            objRs = new ResultSetHelper(reqInfoDelegate.getRecordList(objParams));

             /**�䱸���� �����ȸ�� ��� ��ȯ.*/
            intTotalRecordCount = objRs.getTotalRecordCount();
             intCurrentPageNum = objRs.getPageNumber();
             intTotalPage = objRs.getTotalPageCount();
        }
    } catch(AppException e) {
        objMsgBean.setMsgType(MessageBean.TYPE_ERR);
          objMsgBean.setStrCode(e.getStrErrCode());
          objMsgBean.setStrMsg(e.getMessage());
          out.println("<br>Error!!!" + e.getMessage());
          return;
     }
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<style type="text/css">
	.tooltip_text, .tooltip_close{
		cursor: pointer;
	}
	div.tooltip {
		
		position:absolute;
	}
</style>
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
    var f;
    // �䱸�� ����
    function goReqDocView() {
        NewWindow('/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID %>&ReqTp=<%= CodeConstants.REQ_ORGAN_PERSON %>', '', '800', '600');
        //window.open("/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID %>&ReqTp=<%= CodeConstants.REQ_ORGAN_PERSON %>", "", "resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
    }

    /** �亯�� ���� */
    function viewAnsDoc(){
          window.open("/reqsubmit/common/AnsDocView.jsp?ReqBoxId=<%= (String)objParams.getParamValue("ReqBoxID") %>", "",
    "resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
    }

    // �䱸 ��� ��ȸ
    function goReqBoxList() {
        f = document.viewForm;
        f.target = "";
        f.action = "SMakeEndBoxList.jsp";
        f.submit();
    }

    // ���Ĺ�� �ٲٱ�
    function changeSortQuery(sortField, sortMethod){
        f = document.viewForm;
        f.target = "";
         f.ReqInfoSortField.value = sortField;
          f.ReqInfoSortMtd.value = sortMethod;
          f.submit();
      }

      // �䱸 �󼼺���� ���� */
      function gotoDetail(strID){
          f = document.viewForm;
          f.ReqID.value = strID;
        f.target = "";
         f.action="SMakeEndReqInfoVList.jsp";
          f.submit();
      }

      // ����¡ �ٷΰ���
      function goPage(strPage){
          f = document.viewForm;
          f.ReqInfoPage.value = strPage;
        f.target = "";
          f.submit();
      }

      /**
       * 2005-10-20 kogaeng ADD
       * üũ�ڽ��� �ϳ��� �����ϰ� �ϴ� ��ũ��Ʈ
       */
      function checkBoxValidate(cb) {
        if(<%= intTotalRecordCount %> == 1) {
            if(cb == 0) {
                document.viewForm.ReqInfoID.checked = true;
                document.viewForm.ReqID.value = document.viewForm.ReqInfoID.value;
                return;
            }
        }
        for (j = 0; j < <%= intTotalRecordCount %>; j++) {
            if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
                document.viewForm.ReqInfoID[j].checked = false;
                if (j == cb) {
                    document.viewForm.ReqInfoID[j].checked = true;
                    document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
                } else {
                    document.viewForm.ReqInfoID[j].checked = false;
                    document.viewForm.ReqID.value = "";
                }
            }
        }
    }


      /** �䱸 �̷º��� */
    function viewReqHistory() {
        var cnt = 0;
        if(<%= intTotalRecordCount %> == 1) {
            if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
        } else {
            for (j = 0; j < <%= intTotalRecordCount %>; j++) {
                if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
                    document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
                    cnt++;
                }
            }
        }

          if(cnt == 0) {
              alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
              return;
          }
          var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.viewForm.ReqID.value,
                                                                  '', 'dialogWidth:540px;dialogHeight:450px; center:yes; help:no; status:no; scroll:yes; resizable:yes');
    }
</script>

<script type="text/javascript">
	$(document).ready(function(){
		//alert ('jQuery running');
		
		/* �⺻ ������ ���� */
		var defaults = {
			w : 170, /*���̾� �ʺ�*/
			padding: 0,
			bgColor: '#F6F6F6',
			borderColor: '#333'
		};
		
		var options = $.extend(defaults, options);
		
		/* ���̾� â �ݱ� */
		$(".tooltip_close").click(function(){
			$(this).parents(".tooltip").css({display:'none'});
		});
		
		/* ���콺 ������ */
		$('span.tooltip_text').hover(
			function(over){

				var top = $(this).offset().top;
				var left = $(this).offset().left;
				
				$(".tooltip").css({display:'none'});
				
				$(this).next(".tooltip").css({
					display:'',
					top:  top + 20 + 'px',
					left: left + 'px',
					background : options.bgColor,
					padding: options.padding,
					paddingRight: options.padding+1,
					width: (options.w+options.padding)
				});
				
				
			},
			/* ���콺 �ƿ��� */			   
			function(out){
				//$(this).html(currentText);
				//$('#link-text').pa
			}
		);
		
		


		
	});
	
	function test(){
		//$("button").next().css()
		//$("button").css({top});
	}
</script>
</head>

<body>
<div id="balloonHint" style="display:none;height:100px">
<table border="0" cellspacing="0" cellpadding="4">
    <tr>
        <td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,����;font-weight:bold">�䱸<BR>��<BR>����</font></td>
        <td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
            <font style="font-size:11px;font-family:verdana,����">{{hint}}</font>
        </td>
    </tr>
</table>
</div>
<div id="wrap">
<div id="balloonHint" style="display:none;height:100px">
<table border="0" cellspacing="0" cellpadding="4">
    <tr>
        <td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,����;font-weight:bold">�䱸<BR>��<BR>����</font></td>
        <td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
            <font style="font-size:11px;font-family:verdana,����">{{hint}}</font>
        </td>
    </tr>
</table>
</div>
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
           <!-- pgTit -->
         <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>
<%= MenuConstants.REQ_BOX_MAKE_END %>

 <span class="sub_stl" >- <%= MenuConstants.REQ_BOX_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> >  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE_END%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->


      <!-- contents -->

      <div id="contents">
<form name="viewForm" method="post" action="" style="margin:0px">
                    <!-- �䱸�� ��� ���� ���� -->
                    <input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
                    <input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>"><!--�䱸�Ը�������ʵ� -->
                    <input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>"><!--�䱸�Ը�����Ĺ��-->
                    <input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>"><!--�䱸�� ������ ��ȣ -->
                    <% if(StringUtil.isAssigned(strReqBoxQryTerm)) { %>
                    <input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>"><!--�䱸�� ��ȸ�ʵ� -->
                    <input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>"><!--�䱸�� ��ȸ�ʵ� -->
                    <% } //�䱸�� ��ȸ� �ִ� ��츸 ����ؼ� ����� %>

                    <!-- �䱸 ��� ���� -->
                    <input type="hidden" name="ReqID" value=""> <!-- �䱸 ID -->
                    <input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--�䱸���� ��������ʵ� -->
                    <input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--�䱸���� ������Ĺ��-->
                    <input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- �䱸���� ������ ��ȣ -->
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸�� ��� ���� </span>
        <div class="top_btn"><samp>
            <span class="btn"><a href="javascript:goReqBoxList()">�䱸�� ���</a></span>
        </samp></div>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col" width="100">&bull;&nbsp;�䱸�Ը� </th>
              <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %>
              <%
                // 2004-06-15 ADD
                String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
                if (StringUtil.isAssigned(strElcDocNo)) {
                    out.println(" (���ڰ����ȣ : "+strElcDocNo+")");
                }
            %>
              </td>

            </tr>

            <tr>

              <th scope="col">&bull;&nbsp;�Ұ� ����ȸ </th>   <td><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>

            </tr>
            <tr>

              <th scope="col">&bull;&nbsp;�������� </th>   <td><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>

            </tr>
             <tr>

              <th scope="col">&bull;&nbsp;�߼����� </th>   <td colspan="3">
 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
     <tr>
         <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
         <td><%=(String)objRsSH.getObject("REQ_ORGAN_NM")%></td>
         <td rowspan="2"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
         <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
         <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
     </tr>
     <tr>
         <td class="fonts">
         <%=(String)objRsSH.getObject("REGR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("REGR_EMAIL")%>"><%=(String)objRsSH.getObject("REGR_EMAIL")%></a> / <%=(String)objRsSH.getObject("REGR_CPHONE")%>)
         </td>
         <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%></td>
     </tr>
 </table>
</td>

            </tr>
                <tr>
              <th scope="col" rowspan="2">&bull;&nbsp;�䱸���̷� </th>
              <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;�䱸�� �����Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
             <li><span class="tl">&bull;&nbsp;�䱸�� ������ :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              </ul>
              </td>
            </tr>
            </tr>
            <tr>
              <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;������ ��ȸ�Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;������� :</span> <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>
              <li><span class="tl">&bull;&nbsp;������������ :</span> <%= StringUtil.getDate2(String.valueOf(objRsSH.getObject("LAST_ANS_DOC_SND_DT"))) %></li>
              </ul>
              </td>
            </tr>
                <tr>

              <th scope="col">&bull;&nbsp;����/�䱸 </th>   <td colspan="3"><%= objRsSH.getObject("SUBMT_CNT") %> / <%= objRsSH.getObject("REQ_CNT") %> </td>

            </tr>
            </tr>
                <tr>

              <th scope="col">&bull;&nbsp;�䱸�Լ��� </th>   <td colspan="3"><%= objRsSH.getObject("REQ_BOX_DSC") %> </td>

            </tr>





        </table>

        <!-- /list view -->
        <p class="warning mt10">* �䱸�� ������ ���������� ��ϵ� �䱸�� ���� �亯�� �ۼ����� ���� ��쿡�� �����մϴ�. </p>
 <p class="warning ">�䱸�� ���縦 ���� ������ �䱸���� �ۼ��� �䱸�Կ��� Ȯ���Ͻ� �� �ֽ��ϴ�. </p>
        <!-- ����Ʈ ��ư-->
<!--
�䱸�� ���, �䱸�� ����, �亯�� ����
-->
        <div id="btn_all"><div  class="t_right">
            <div class="mi_btn" style="float:right"><a href="javascript:goReqDocView()"><span>�䱸�� ����</span></a></div>
            <div class="mi_btn" style="float:right"><a href="javascript:viewAnsDoc()"><span>�亯�� ����</span></a></div>
        </div></div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� (<%= intCurrentPageNum %> / <%= intTotalPage %> page)</span></span>

        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px; ">
                <input name="" type="checkbox" value="" class="borderNo" />
              </th>
              <th scope="col" style="width:15px; "><a>NO</a></th>
              <th scope="col" style="width:250px;" ><%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "�䱸����") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "����") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "�������") %></th>
              <th scope="col"><a>�亯</a></th>
              <th scope="col"><a>÷��</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqInfoSortField, strReqInfoSortMtd, "�������")%></th>

            </tr>
          </thead>
          <tbody>
        <%
            int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
            String strReqInfoID = "";
            while(objRs.next()){
                strReqInfoID = (String)objRs.getObject("REQ_ID");
        %>
            <tr>
              <td>
                <input name="ReqInfoID" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-1) %>)"/>
              </td>
              <td><%= intRecordNumber %></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%= strReqInfoID %>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %> ..."><%= objRs.getObject("REQ_CONT") %></a>
              </td>
              <td><%= CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
              <td><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
              <td><span class="tooltip_text"><%=this.makeAnsInfoImg((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></span> 
				<div class="tooltip" style="display:none;">
					<table width=100% height=100%>
					  <tr>
					   <td width=100% height=5% style="align:right">
						<img src="/images/bt-close.gif" style="cursor:hand" align="absmiddle" border="0" class="tooltip_close">
					   </td>
					  </tr>
					  <tr> 
					   <td  bgcolor="#FFFFFF" align="left" ><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","",StringUtil.substring((String)objRs.getObject("REQ_CONT"),35),(String)objRsSH.getObject("SUBMT_ORGAN_NM"))%></td>
					  </tr>
					 </table>
				</div></td>
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
            </tr>
        <%
                intRecordNumber++;
            } //endwhile
        %>
          </tbody>
        </table>

        <!-- /list -->
                    <%=objPaging.pagingTrans(PageCount.getLinkedString(
                            new Integer(intTotalRecordCount).toString(),
                            new Integer(intCurrentPageNum).toString(),
                            objParams.getParamValue("ReqInfoPageSize")))%>
        <!-- ����¡-->
        <!-- /����¡-->


       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%> value="req_cont">�䱸����</option>
           <option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%> value="req_dtl_cont">�䱸����</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
         class="li_input"  style="width:100px" value="<%= strReqInfoQryTerm %>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="javascript:viewForm.submit()"/> </div>
        <!-- /����Ʈ �� �˻� --> <span class="right"> <span class="list_bt"><a href="#" onclick="javascript:viewReqHistory()">�䱸�̷º���</a></span></span> </div>

        <!-- /����Ʈ ��ư-->
        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
<%!
    public String makeAttachedFileLink(String strFileName){
        String strReturnURL = null;
        if(!StringUtil.isAssigned(strFileName)){
            //���ϰ�ΰ� ������ �⺻ ���ϰ�η� ��ġ��.
            strReturnURL = "";
            //strFileName=nads.lib.reqsubmit.EnvConstants.getConstFilePath();
        } else {
            strReturnURL = "<a href=\"/reqsubmit/common/AttachStyleFileDownload.jsp?path=" + strFileName+ "\"><img src=\"/image/common/icon_etc.gif\" border=\"0\"></a>";
        }
        return strReturnURL;
    }

%>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>

<%!

	public static String makeAnsInfoHtml2(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary,String strReqCont,String strSubmtorganNm){
		if(strLinkTarget.equals("0")){
			strLinkTarget="_blank";
		}else if(strLinkTarget.equals("1")){
			strLinkTarget="_self";
		}
		String strMsgSummary=StringUtil.getEmptyIfNull(strSummary,"PDF����");
		String strTop="";		//��¿� ��� ���ڿ�<a><talbe>
		String strMiddle="";	//��¿� �߰� <tr></tr>+
		String strBottom="";	//��¿� �ϴ� ���ڿ�..</table></a>
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "";//�亯���� ������.
		}
		if(strAnsOpins!=null){
			strAnsOpins=strAnsOpins.replaceAll("'"," ");
			strAnsOpins=strAnsOpins.replaceAll("\""," ");
		}else{
			strAnsOpins="";
		}
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			strAnsOpin=StringUtil.getEmptyIfNull(strAnsOpin);
			strAnsOpin=strAnsOpin.replace('\n',' ');
			strAnsOpin=strAnsOpin.replace('\r',' ');
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				//<tr>����
				if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					if(StringUtil.isAssigned(strKeywords)){
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpenHL.jsp?ansID=" + strAnsID + "&keyword=" +  strKeywords+ "&DOC=PDF' target='" + strLinkTarget + "'>");						
					}else{
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtorganNm+"' target='_self'>");
					}
					/** ���ŵ� 2004.05.13
					if(intAnsCount>0){//ó���ѹ��� ��๮ �����شٰ���.
						strMsgSummary="PDF����";
					}
					 */
					strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='" + strMsgSummary + "'>");
					strBufReturn.append("</a>");
					strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtorganNm+"' target='_self'>");
					strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='��������'>");
					strBufReturn.append("</a>");
					strBufReturn.append("<br>");
				}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}else if(strAnsMtd.equals("004")){
					strBufReturn.append("<img src='/image/reqsubmit/bt_offLineSubmit.gif' width='73' height='16' border='0' alt='���������� ���� ����'>");
					strBufReturn.append("<br>");					
				}else {
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}
				//</tr>�� 
				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}
		
		strMiddle=strBufReturn.toString();//�߰����ڿ� �ޱ�.
		
		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return  strMiddle;
		}else{
			return "";//�亯���� ������.
		}
	}

	public static String makeAnsInfoImg(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary){
		
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//�亯���� ������.
		}		
				
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){	
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}				
		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return "<img src='/image/reqsubmit/icon_answer.gif' border='0'>";
		}else{
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//�亯���� ������.
		}
	}

%>