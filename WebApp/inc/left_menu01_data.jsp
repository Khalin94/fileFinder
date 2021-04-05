<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ page import="nads.lib.message.MessageBean" %>

<%
    String docbox_idRQ = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));
    String strUserId = (String)session.getAttribute("USER_ID");  //사용자 ID
    String strMainOrganIdLeft = (String)session.getAttribute("ORGAN_ID");  //사용자 주 기관ID
    String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));  //좌측메뉴에서 클릭한 분류함ID
    String strOrganId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));  //좌측메뉴에서 클릭한 기관ID
    String strOrganIdLeft = "";  //분류함의 기관ID
    String strDocboxIdLeft = "";  //분류함ID
    String strDocboxNmLeft = "";  //분류함명
    String strTopDocboxIdLeft = "";  //분류함의 상위분류함ID
    String strSeqLeft = "";  //분류함(폴더)의 단계(1,2,3...)
    String strNumber = "";  //분류함(폴더)의 단계==>(strSeqLeft + 3) /2 == 몫)
    String strNmMenuLeft = "";  //분류함(폴더)의 단계(0,2,4...)
    String strsession1 = (String)session.getAttribute("clickid")==null?"0":(String)session.getAttribute("clickid");
    String strsession2 = (String)session.getAttribute("oldclickid")==null?"999":(String)session.getAttribute("oldclickid");
    String clickid = request.getParameter("clickid")==null?strsession1:request.getParameter("clickid");
    String oldclickid = request.getParameter("oldclickid")==null?strsession2:request.getParameter("oldclickid");

    if (clickid.equals(oldclickid)&&strDocboxId.equals("0")) {
        clickid = "999";
    }

    session.setAttribute("clickid",clickid);
    session.setAttribute("oldclickid",oldclickid);

    oldclickid = clickid;
    Hashtable objDocboxLeftHt = new Hashtable();
    ArrayList objDocboxLeftArry = new ArrayList();

    try
    {
        nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();
        objDocboxLeftArry = objBusInfoDelegate.selectOrganDocboxList(strUserId);
    } catch (AppException objAppEx) {

        //에러 발생 메세지 페이지로 이동한다.
        objMsgBean.setMsgType(MessageBean.TYPE_ERR);
        objMsgBean.setStrCode(objAppEx.getStrErrCode());
        objMsgBean.setStrMsg(objAppEx.getMessage());
        //out.println("메뉴목록 조회 중 에러 발생 || 메세지 페이지로 이동");
%>
        <jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
        return;
    }
%>
<script language="javascript">
    function fun_delete(){
        form_main.submit();
    }
    function fun_organ(strDocboxId, strOrganId){
        strTmp = "/activity/BizInfo.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrganId;
        parent.location.href = strTmp;
    }
    function fun_open(strOrganId){
        strTmp = "/activity/OpenBizInfo.jsp?organ_id=" + strOrganId;
        parent.location.href = strTmp;
    }
    function fun_organleft(strDocboxId, strOrganId,click){
        strTmp = "/activity/BizInfo.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrganId + "&clickid="+click+"&oldclickid="+<%=oldclickid%>;
        parent.location.href = strTmp
    }

    function fun_alldutyinfo(strInTmp, strOrganId){  //strInTmp : 사용하지 않는 변수로 fun_organleft와 변수개수를 맞추기 위해 사용.
        strTmp = "/activity/AllOrganBizInfo.jsp?organ_id=" + strOrganId+"&clickid=999";
        parent.location.href = strTmp
    }
	function menuOpenFold(id){
		if(document.getElementById(id).style.display == "none"){
			document.getElementById(id).style.display = "";
		} else {
			document.getElementById(id).style.display = "none"
		}
	}

</script>

<div id="left_menu">
  <h2><img src="/images2/foundation/tl01.gif" width="192" height="44" /></h2>
  <ul>
    <li>
      <span class="on"><a href="/activity/BizInfo.jsp">부서자료실</a></span>

         <ul class="dep3">
            <li>
            <%
                    String strUserAllOrganId = "";
                    String strOrgGbn = "";
                    int click = 0;
                    boolean openYn = false;
                    for (int i=0; i < objDocboxLeftArry.size(); i++)
                    {
                        objDocboxLeftHt = (Hashtable)objDocboxLeftArry.get(i);
                        strOrganIdLeft = (String)objDocboxLeftHt.get("ORGAN_ID");
                        strDocboxIdLeft = (String)objDocboxLeftHt.get("DOCBOX_ID");
                        strDocboxNmLeft = (String)objDocboxLeftHt.get("DOCBOX_NM");
                        strNmMenuLeft = (String)objDocboxLeftHt.get("NM_MENU");
                        strTopDocboxIdLeft = (String)objDocboxLeftHt.get("TOP_DOCBOX_ID");
                        strSeqLeft = (String)objDocboxLeftHt.get("SEQ");
                        //strDocboxNmLeft = nads.lib.util.ActComm.chgSpace(strDocboxNmLeft);

                        if (strDocboxIdLeft.equals("M")){
                            strUserAllOrganId = strUserAllOrganId + "," + strOrganIdLeft;
                            strNumber = "1";
                            strOrgGbn = (String)objDocboxLeftHt.get("ORG_POSI_GBN") ;
                            if(!strOrgGbn.equals("1")){   //겸직 구분 '1'->원직
                                strNmMenuLeft = "(겸무)" + strNmMenuLeft;
                            }
                            if (openYn){
            %>
                                </ul>
            <%              }%>
                            <!--fun_organleft('0', '<%=strOrganIdLeft%>');menuOpenFold('<%=i%>');-->
                            <h4><a href="javascript:fun_organleft('0', '<%=strOrganIdLeft%>','<%=i%>');"><%=strNmMenuLeft%></a></h4>
                                <ul class="dep4" id="<%=i%>"
                                <%if(!clickid.equals(i+"")){%>
                                style="display:none"
                                <%}%>
                                >
            <%
                                click = i ;
                                openYn = true;
                        }else{
                            strNumber = Integer.toString((Integer.parseInt(strSeqLeft) + 3) /2) ;
            %>

                            <li>
                            <%if(docbox_idRQ.equals(strDocboxIdLeft)){%>
                             <span class="on"><h5><a href="javascript:fun_organleft('<%=strDocboxIdLeft%>', '<%=strOrganIdLeft%>','<%=click%>')"> - <%=strNmMenuLeft%></a></h5></span>
                            <%}else{%>
                             <h5><a href="javascript:fun_organleft('<%=strDocboxIdLeft%>', '<%=strOrganIdLeft%>','<%=click%>')"> - <%=strNmMenuLeft%></a></h5>
                            <%}%>
                            </li>
            <%
                        }
                    }
                    if (openYn) out.print("</ul>");
                    strNumber = "1";
            %>
            </li>
            <!--따로 추가 한것 같음-->
            <li>
              <h4><a href="javascript:fun_alldutyinfo('', '<%=strUserAllOrganId%>')">소속부서자료조회</a></h4>
            </li>
      </ul>
    </li>
  </ul>
  <p><img src="/images2/foundation/tl_bottom.gif" width="192" height="15" /></p>
</div>
