<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>

<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part  														  */
 /*************************************************************************************************/
 /**요구함 목록 */
 ResultSetHelper objReqBoxRs=null;
 /**요구함정보 대리자 */
 RequestBoxDelegate objReqBox=null;
 String strMainIsRequeser=(String)request.getSession().getAttribute("IS_REQUESTER");
 String strReqBoxStt = request.getParameter("REQ_BOX_STT")==null?"000":request.getParameter("REQ_BOX_STT");

 if(strMainIsRequeser.equals("false") && strReqBoxStt.equals("000")){
	strReqBoxStt = "006";
 }
 
 System.out.println("Main stt "+strReqBoxStt);
 System.out.println("Main requester "+strMainIsRequeser);
 try{
   /** 제출자 요구함 목록  출력 대리자.*/
   objReqBox=new RequestBoxDelegate();
   System.out.println("----------------------------------------------------------------------");
   objReqBoxRs=objReqBox.getMainReqBoxList2((String)request.getSession().getAttribute("ORGAN_ID"),(String)request.getSession().getAttribute("ORGAN_KIND"),strMainIsRequeser,strReqBoxStt);
   System.out.println("----------------------------------------------------------------------");
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
 	String strBoxOutDate = "";
	if(objReqBoxRs.getRecordSize() >0) {//목록이 있으면.
		String strReqBox = "";
		int cnt = 0;
		while(objReqBoxRs.next()){
			if(cnt==4) break;
%>
		<tr>
		  <td height="18" class="newReqBoxList"><img src="image/main/icon_bluedot.gif" width="3" height="4" align="absmiddle">
<%
            System.out.println("ssssssssssssssss"+(String)objReqBoxRs.getObject("REQ_BOX_TP"));
			out.print("<a href=\"" + objReqBox.getGotoMainReqBoxLink2(objReqBoxRs,(String)objReqBoxRs.getObject("REQ_BOX_STT")) + "\">");
			strReqBox = "[";
			if(strMainIsRequeser.equalsIgnoreCase("true")){//요구자
				strReqBox = strReqBox + (String)objReqBoxRs.getObject("SUBMT_ORGAN_NM");//제출기관명
			}else{//제출자
				strReqBox = strReqBox + (String)objReqBoxRs.getObject("REQ_ORGAN_NM");//요구기관명
			}
		    strReqBox = strReqBox + "] ";

			String tempReqBoxNM = (String)objReqBoxRs.getObject("REQ_BOX_NM");
			if(tempReqBoxNM.length() > 20){
				tempReqBoxNM = tempReqBoxNM.substring(0,20) + "...";
			}

		    strReqBox = strReqBox + tempReqBoxNM ;//요구내용 20자만 가져오기...

			strBoxOutDate = (String)objReqBoxRs.getObject("REG_DT");//등록일
%>
            <%=nads.lib.util.ActComm.chrString(strReqBox,  46)   %>
		    </a>
	      </td>
	      <td width="80px;" align="right" class="newReqBoxList">[<%=nads.lib.reqsubmit.util.StringUtil.getDate(strBoxOutDate)%>]</td>

		</tr>
	  <%
			cnt++;
		}//endofwhile
	}else{
		out.println("<tr>");
		out.println("<td  height='18' class='newReqBoxList'><img src='image/main/icon_bluedot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");
	}//endif목록체크.
%>
<%
// 탭 설정에 따른 리스트 조회

	String strStatus1 = "";
	String strStatus2 = "";
	String strStatus3 = "";
	String strStatus4 = "";
	String strEventText1 = "";
	String strEventText2 = "";
	String strEventText3 = "";
	String strEventText4 = "";

	if ("000".equals(strReqBoxStt)){	// 전체
		strStatus1 = "_on";
		strStatus2 = "";
		strStatus3 = "";
		strStatus4 = "";
		strEventText1 = "";
		strEventText2 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText3 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	} else if ("003".equals(strReqBoxStt)) {	// 의원 : 작성중, 기관 : X, 위원회 : 접수완료
		strStatus1 = "";
		strStatus2 = "_on";
		strStatus3 = "";
		strStatus4 = "";
		strEventText1 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText2 = "";
		strEventText3 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	} else if ("006".equals(strReqBoxStt)) {	// 의원, 위원회 : 발송완료, 기관 : 작성중
		strStatus1 = "";
		strStatus2 = "";
		strStatus3 = "_on";
		strStatus4 = "";
		strEventText1 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText2 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText3 = "";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	} else if ("007".equals(strReqBoxStt)) {	// 제출완료
		strStatus1 = "";
		strStatus2 = "";
		strStatus3 = "";
		strStatus4 = "_on";
		strEventText1 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText2 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText3 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText4 = "";
	}

%>
<script>


  jQuery(document).ready(function(){
	jQuery("#topImgList").find("img").click(function(){
		jQuery("#REQ_BOX_STT").val($(this).attr("id"));
		jQuery("#frmMain").submit();
	});
  });


</script>
<form id="frmMain" name="frmMain" method="post">
	<input type="hidden" id="REQ_BOX_STT" name="REQ_BOX_STT" value="<%=strReqBoxStt%>" />
</form>

<h3 id="topImgList" >
	<%if("true".equals(strMainIsRequeser)){ %>
	<!-- 의원실 -->
	<img id="000" src="images2/main/stl01_box_01<%=strStatus1%>.gif" width="32" height="14" <%=strEventText1%> style="cursor:hand;"/><img id="003" src="images2/main/stl01_box_02<%=strStatus2%>.gif" width="41" height="14" <%=strEventText2%> style="cursor:hand;"/><img id="006" src="images2/main/stl01_box_04<%=strStatus3%>.gif" width="52" height="14" <%=strEventText3%> style="cursor:hand;"/><img id="007" src="images2/main/stl01_box_05<%=strStatus4%>.gif" width="49" height="14" <%=strEventText4%> style="cursor:hand;"/>
	<%}else{ %>
	<!-- 기관 -->
	<img id="000" src="images2/main/stl01_box2_01<%=strStatus1%>.gif" width="34" height="14" <%=strEventText1%> style="cursor:hand;"/><img id="006" src="images2/main/stl01_box2_02<%=strStatus3%>.gif" width="49" height="14" <%=strEventText3%> style="cursor:hand;"/><img id="007" src="images2/main/stl01_box2_03<%=strStatus4%>.gif" width="57" height="14" <%=strEventText4%> style="cursor:hand;"/>
	<%} %>
	<!-- 위원회
	<img id="000" src="images2/main/stl01_box_01<%=strStatus1%>.gif" width="32" height="14" <%=strEventText1%> /><img id="003" src="images2/main/stl01_box_03<%=strStatus2%>.gif" width="51" height="14" <%=strEventText2%> /><img id="006" src="images2/main/stl01_box_04<%=strStatus3%>.gif" width="52" height="14" <%=strEventText3%> /><img id="007" src="images2/main/stl01_box_05<%=strStatus4%>.gif" width="49" height="14" <%=strEventText4%> />-->
</h3>