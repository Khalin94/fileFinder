<%
 	java.util.Hashtable objLeftMenuMainCntHash = null;//�䱸�������ϱ� �ؽ�.
 	boolean blnLeftMenuIsRequester = false;
 	nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate objLeftMenuReqInfo = null;
 	try {
   		blnLeftMenuIsRequester = Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();

   		objLeftMenuReqInfo = new nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate();
   		objLeftMenuMainCntHash = objLeftMenuReqInfo.getMainReqCount((String)request.getSession().getAttribute("ORGAN_ID"),blnLeftMenuIsRequester,(String)request.getSession().getAttribute("ORGAN_KIND"));
 	} catch(kr.co.kcc.pf.exception.AppException objAppEx) {
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
  		return;
 	}
%>

<script language="javascript">
	parent.COUNT.style.display = '';
	parent.COUNTS.reqcount.value='�䱸 : <%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"REQ_SUM","0") %>��';
	parent.COUNTS.submtcount.value='���� : <%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"SUBMT_SUM","0") %> ��';
	parent.COUNTS.notsubmtcount.value='������ �ڷ� : <%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"DIFF_SUM","0") %> ��';
	parent.COUNTS.limitcount.value='���Ѱ���ڷ� : <%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"DELAY_SUBMT","0") %> ��';
</script>
