<%
 	java.util.Hashtable objLeftMenuMainCntHash = null;//요구개수구하기 해쉬.
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
	parent.COUNTS.reqcount.value='요구 : <%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"REQ_SUM","0") %>건';
	parent.COUNTS.submtcount.value='제출 : <%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"SUBMT_SUM","0") %> 건';
	parent.COUNTS.notsubmtcount.value='미제출 자료 : <%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"DIFF_SUM","0") %> 건';
	parent.COUNTS.limitcount.value='기한경과자료 : <%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"DELAY_SUBMT","0") %> 건';
</script>
