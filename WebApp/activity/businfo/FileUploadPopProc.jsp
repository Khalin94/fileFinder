<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.util.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	boolean blnRlt = true;
	Vector objFileRealVt = new Vector();
	String strDeleteDir = "";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

/***************************************************************************/

		/**** file upload ****/
		FileUpload fileup=new FileUpload(request.getInputStream());

		String strDocboxId = (String)fileup.getParameter("docbox_id");
		String strOrganId = (String)fileup.getParameter("organ_id");
		String strMaxSize = StringUtil.getNVL((String)fileup.getParameter("max_size"), "0");
		String strUsingSize = StringUtil.getNVL((String)fileup.getParameter("using_size"), "0");
			
		if(strMaxSize.equals("")) 	strMaxSize = "0";
		if(strUsingSize.equals("")) 	strUsingSize = "0";
		long lMaxSize = Long.parseLong(strMaxSize);
		long lUsingSize = Long.parseLong(strUsingSize);
					
		String strFile = "";
		String strReal = "";
		String strOpen = "";
		String strRemark = "";
		boolean blntmp = true;
			
		Hashtable objOpenHt = new Hashtable();
		Hashtable objSeqHtable = new Hashtable();
		Vector objParam = new Vector();
		int iResult = 0;

		Vector objRemarkVt = new Vector();  //�� ��������(����)�� ���� ����
		Vector objOpenVt = new Vector();     
		Vector objFileVt = new Vector();
		Vector objRealVt = new Vector();
		Vector objSizeVt = new Vector();

		long lSize;
		long lTotSize = 0L;
		int iReturn = 0;

		String strOrgNameTemp = null;
		boolean flag = false;
											
		for(int i=0; i < 5; i++){
			//��ü���� Checkbox��check���� �� ÷������ �� ��ȸ	
			objOpenHt = fileup.getOpenYn("check2");     //checkbox name ==> check2 : (05/12 :checkbox ����)
			strOpen = (String)objOpenHt.get("OPEN");    //��ü�������� ������ '002'�� setting
			strFile =  ActComm.fromDB((String)objOpenHt.get("FILE"));  //���ε� ���ϸ�
				
			if (strOpen.equals("001")){ //��ü������ check �Ǿ��� ���� ���ϸ��� ������ ��ȸ�Ѵ�.-->��ü�������� ������ �����ص� ����--������ ���� �������� ����
				strFile  = ActComm.fromDB((String)fileup.getFileName());
			}
			
			strOrgNameTemp = strFile;
			System.out.println("strOrgNameTemp : "+strOrgNameTemp);
			if(strOrgNameTemp != null && !strOrgNameTemp.equals("")&& !strOrgNameTemp.equals("0")){				
				int pos = strOrgNameTemp.lastIndexOf(".");
				//String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);
				String strExtension = strOrgNameTemp.substring(pos+1);
				strExtension = strExtension.toLowerCase();
				String[] strEx = {"hwp", "pdf", "zip", "alz", "doc", "ppt", "xls", "txt","xlsx","docx","pptx"};
				
				for(int k = 0; k < strEx.length ; k++){
					if(strEx[k].equals(strExtension)){
						flag = true;
					}
				}
				if(flag == false){
					out.println("<script language=javascript>");
					out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt ������ ���ϸ� ���ε尡���մϴ�.');");	
					out.println("history.back();");
					out.println("</script>");
					return;
				}			
			}			
			flag = false;

			//���ε� �� ������ ������ ���� ������ �ִ� ������ �Է¶��� �б⸸ �ϰ� ���̺� ������ ���� ����
			if ((strFile == null) || (strFile.length() < 1) || (strFile.equals("0"))) {
				switch (i){
					case 0 :
						strRemark = (String)fileup.getParameter("tx1");  //���Ͽ� ���� ���� ��ȸ
						break;
					case 1 :
						strRemark = (String)fileup.getParameter("tx2");
						break;
					case 2 :
						strRemark = (String)fileup.getParameter("tx3");
						break;
					case 3 :
						strRemark = (String)fileup.getParameter("tx4");
						break;
					case 4 :
						strRemark = (String)fileup.getParameter("tx5");
						break;				
				}
				continue;
			} 

			if (strRemark == null) strRemark = "";
			
			/*************** file upload(�������� ������ �о��) ***********************************/
			strReal = strUserId + "_" + Integer.toString(i) + "_" + fileup.getKST("yyyyMMddHHmmss") + strFile;
			FileOutputStream upfile = new FileOutputStream(AdminIo.getDefaultDirTmp()  + strReal);
			fileup.UpFile(upfile);
			upfile.close();
			lSize = AdminIo.sizeIo(AdminIo.getDefaultDirTmp()  + strReal);  //���� ������
			/************************************************************/
			if(lSize <= 0){  //���� ����� '0'�� ��쿡�� ���ε带 ���� �ʴ´�.
				strDeleteDir = AdminIo.getDefaultDirTmp() + strReal;
				blnRlt = AdminIo.deleteIo(strDeleteDir) ;
				continue;
			}
			objFileRealVt.add(strReal);
						
			/*******���� ������ ���� ***************************************/
			lTotSize = lTotSize + lSize; 
			//���ε��ϰ����ϴ� ���ϵ��� ũ�Ⱑ �ִ� ���ε� ���� ũ�� ���� Ŭ ��� �����޽��� ���
			//���ε��ϰ����ϴ� ���ϵ��� ũ�Ⱑ ����Ҽ� �ִ� �������� Ŭ ��� �����޽��� ���
			if((lTotSize > lMaxSize) || (lTotSize > lUsingSize)){  
				/**���� �޽��� ��½� ���ε�� ���ϵ� ���� **/			
				if(objFileRealVt != null){
					for(int k=0; k < objFileRealVt.size() ; k++){
						strDeleteDir = AdminIo.getDefaultDirTmp() + (String)objFileRealVt.elementAt(k);
						blnRlt = AdminIo.deleteIo(strDeleteDir) ;
						if (blnRlt == false) continue;
					}
				}
				strMessage = "������ ���ϻ���� �ʹ� Ů�ϴ�";
%>
<script language="javascript">
<!--
	alert("<%=strMessage%>");
	history.back();
//-->
</script>
<%
				return;
			}
			/*************************************************************/

			switch (i){
				case 0 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx1"));
					break;
				case 1 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx2"));
					break;
				case 2 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx3"));
					break;
				case 3 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx4"));
					break;
				case 4 :
					strRemark = ActComm.fromDB((String)fileup.getParameter("tx5"));
					break;				
			}
			
			objRemarkVt.add(strRemark);
			objOpenVt.add(strOpen);
			objFileVt.add(strFile);
			objRealVt.add(strReal);
			objSizeVt.add(Long.toString(lSize));
		}//for(int i=0; i < 5; i++)
		
		if (objFileVt.size() >= 1){
			Hashtable objParamHt = new Hashtable();
			objParamHt.put("USERID_ID", (String)strUserId);
			objParamHt.put("DOCBOX_ID", (String)strDocboxId);
			objParamHt.put("ORGAN_ID", (String)strOrganId);
			objParamHt.put("REMARK", (Vector)objRemarkVt);
			objParamHt.put("OPEN", (Vector)objOpenVt);
			objParamHt.put("FILE", (Vector)objFileVt);
			objParamHt.put("REAL", (Vector)objRealVt);
			objParamHt.put("SIZE", (Vector)objSizeVt);
/**************************************************************************/

			int intResult = objBusInfoDelegate.uploadFile(objParamHt);
		
			strMessage = strMessage + String.valueOf(intResult) + "�� ���� �Ǿ����ϴ�.";
		}else{
			strMessage = "������ ������ �����ϴ�.";
			strError = "yes";
		}
	}
	catch(AppException objAppEx)
	{	
		if(objFileRealVt != null){
			for(int k=0; k < objFileRealVt.size() ; k++){
				strDeleteDir = AdminIo.getDefaultDirTmp() + (String)objFileRealVt.elementAt(k);
				blnRlt = AdminIo.deleteIo(strDeleteDir) ;
				if (blnRlt == false) continue;
			}
		}
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<script language="javascript">
<!--
	alert("<%=strMessage%>");
		
	<%if(strError.equals("no")){%>
	opener.location.reload();
    self.window.close(); 
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>
