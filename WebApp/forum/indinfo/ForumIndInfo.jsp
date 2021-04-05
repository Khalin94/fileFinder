<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.session.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/> 

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String urlPath = ""; //http ���

	try {
	
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ

		urlPath = objConfig.get("nads.dsdm.url");

	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
%>

<%
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //ȸ������
	String strOpenFlag = ""; //��������
	String strForumNM = ""; //������

	String strCMD = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd"))); //����:upd

	ArrayList objForumSortData;
	Hashtable objHashForumData;
	CodeInfoDelegate objCodeInfo = new CodeInfoDelegate(); //�ڵ���� Delegate
	SLDBForumDelegate objDBForum = new SLDBForumDelegate();
	
	try {

		objForumSortData = objCodeInfo.lookUpCode("M02");
		objHashForumData = objDBForum.selectIndForumInfo(strForumID);

		strOpenFlag = StringUtil.getNVLNULL((String)objHashForumData.get("OPEN_FLAG"));
		strForumNM = StringUtil.getNVLNULL((String)objHashForumData.get("FORUM_NM"));

	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}
%>

<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
//�̸�����
function prevImg(url,width,height)
{
    var hWin=null;
    hWin = window.open(url, 'prevImg', "toolbar=no,scrollbars=no, width="+width+",height="+height+",resizable=yes, screenX=0,screenY=0,top=100,left=100");
    //hWin = window.open(url);
    hWin.focus();
}

//���� ÷��
function showImageFile(fileValue, showValue) { 
	
	eval("document.form."+showValue+".value = document.form."+fileValue+".value");
	

	var strImgPath = eval("document.form." + fileValue + ".value");

	//alert(strImgPath);

	if(document.all["imgPreView"] != null && strImgPath != "")
	{
		document.all["imgPreView"].src = strImgPath;
	}
}

function formReset()
{	

	document.form.reset();

	if(document.all["imgPreView"] != null)
	{
		document.all["imgPreView"].src = document.form.IMG_PATH_OLD.value;
	}
		
}

function fnChk() {
	if(document.form.FORUM_NM.value=="") {
		alert("�������� �Է��ϼ���.");
		document.form.FORUM_NM.focus();
		return false;
	}

	var openFlag="";
	for (var i = 0; i < document.form.OPEN_FLAG.length; i++) {
		if(document.form.OPEN_FLAG[i].checked) {
			openFlag = document.form.OPEN_FLAG[i].value;
			break;
		}
	}
	if(openFlag=="") {
		alert("�������θ� �����ϼ���.");
		return false;	
	}

	if(document.form.IMG_PATH.value!="") {
		if (LimitAttach(document.form.IMG_PATH.value) == false ) return false;
	}

    if(document.form.FORUM_INTRO.value.length < 1 || document.form.FORUM_INTRO.value.length > 500){
        alert('�����Ұ��� 500�� �̳� �Դϴ�.');
        document.form.FORUM_INTRO.focus();
        return false;	
    }	

	document.form.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top"> 
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
<%@ include file="/forum/common/MenuLeftForumPop.jsp" %>
    </td>
    <td align="center"><table width="589" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="23%" background="/image/forum/bg_forumpop_tit.gif"><span class="title">���� ������� ����</span></td>
                <td width="77%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s">�� ������ ������ �����Ͻ� �� �ֽ��ϴ�.</td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
		<form name="form" method="post" encType="multipart/form-data" action="ForumIndInfoProc.jsp" onSubmit="return fnChk();">
			<input type="hidden" name="cmd" value="<%=strCMD%>">
			<input type="hidden" name="fid" value="<%=strForumID%>">
			<input type="hidden" name="uStt" value="<%=strUserStt%>">
<%
	if(objHashForumData!=null) {

		String strForumSort = StringUtil.getNVLNULL((String)objHashForumData.get("FORUM_SORT")); //�����з�
		String strForumSortNM = "";
		for(int j=0; j< objForumSortData.size(); j++) {
			if(strForumSort.equals(String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD")))) {
				strForumSortNM = String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"));
				break;
			}
		}

		String strEstabTS = (String)objHashForumData.get("ESTAB_TS"); //������
		if(strEstabTS.length() > 8)  {
			strEstabTS = strEstabTS.substring(0, 4) + "-" + strEstabTS.substring(4, 6) + "-" + strEstabTS.substring(6, 8);
		}

		String strOpenFlagY=(strOpenFlag.equals("Y")) ? "checked":"";
		String strOpenFlagN=(strOpenFlag.equals("N")) ? "checked":"";

		String strDisabled = (strCMD.equals("upd")) ? "":"disabled";

		String strImgPath = StringUtil.getNVLNULL((String)objHashForumData.get("IMG_PATH")); //�����̹���
		String strImgPathURL = (strImgPath.equals("")) ? "":urlPath+strImgPath;
		String strForumIntro = StringUtil.getNVLNULL((String)objHashForumData.get("FORUM_INTRO")); //�����Ұ�
		String strReadonly = (strCMD.equals("upd")) ? "":"readonly";
%>
        <tr>
          <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="135" height="2" class="td_forumpop"></td>
                <td width="454" height="2" class="td_forumpop"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �з�</td>
                <td height="25" class="td_lmagin">
				<%
					if(strCMD.equals("upd")) {
				%>
					<select name="FORUM_SORT" class="select">
					<%
						String strSelected="";
						for(int j=0; j< objForumSortData.size(); j++) {
							if(strForumSort.equals(String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD")))) {
								strSelected="selected";
							} else {
								strSelected="";
							}
					%>
						<option value="<%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD"))%>" <%=strSelected%>><%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"))%></option>
					<%
						}
					%>
					</select>
				<%
					} else {
						out.print(strForumSortNM);
					}
				%>
				</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ������</td>
                <td height="25" class="td_lmagin">
				<%
					if(strCMD.equals("upd")) {
				%>
					<input name="FORUM_NM" type="text" class="textfield" style="WIDTH: 300px" value="<%=strForumNM%>" maxlength="50">
				<%
					} else {
						out.print(strForumNM);
					}
				%>
				</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ������</td>
                <td height="25" class="td_lmagin"><%=strEstabTS%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">��������</td>
                <td height="25" class="td_lmagin">
					<input type="radio" name="OPEN_FLAG" value="Y" <%=strOpenFlagY%> <%=strDisabled%>>���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="OPEN_FLAG" value="N" <%=strOpenFlagN%> <%=strDisabled%>>�����
				  </td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="77" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  ���� �̹���</td>
                <td height="77" class="td_lmagin">
				<%
					if(strCMD.equals("upd")) {
				%>	
						
						<input type="text" name="IMG_PATH_TXT" class="textfield" style="WIDTH: 300px" readonly>
						<input type="file" name="IMG_PATH" class="textfield" style="WIDTH: 0px" onChange="javascript:showImageFile('IMG_PATH','IMG_PATH_TXT');"><br>
						<input type="hidden" name="IMG_PATH_OLD" value="<%=strImgPath%>">
						
				<%
					}

					if(!strImgPath.equals("")) {
				%>
						<img name="imgPreView" src="<%=strImgPath%>" width="154" height="77">

						<!-- <a href="javascript:prevImg('<%=strImgPathURL%>','300','300');"><%=strImgPathURL%></a> -->
				<%
					}
				%>
				</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����Ұ�</td>
                <td height="45" valign="top" class="td_box"><textarea name="FORUM_INTRO" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 250" <%=strReadonly%>><%=strForumIntro%></textarea></td>
              </tr>
              <tr height="1"> 
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
              </tr>
            </table></td>
        </tr>
<%
	} //end if(objHashForumData!=null)
	
	if(strCMD.equals("upd")) { //����ȭ���� ���
%>
        <tr>
          <td height="35"><input type="image" src="/image/button/bt_save.gif" width="43" height="20" border="0">&nbsp;<a href="javascript:formReset();"><img src="/image/button/bt_cancel.gif" width="43" height="20" border="0"></a></td>
        </tr>
<%
	} else { //�󼼺��� ȭ���� ���
%>
        <tr>
          <td height="35"><a href="/forum/indinfo/ForumIndInfo.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&cmd=upd"><img src="/image/button/bt_modify.gif" width="43" height="20" border="0">
		  <!-- &nbsp;<img src="/image/button/bt_requestClose.gif" height="20" border="0"> -->
		  </td>
        </tr>
<%
	}
%>
		</form>
        <tr> 
          <td height="15">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
