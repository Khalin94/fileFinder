<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate"%>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	boolean sFlag = true;
	
	String strSystemid = StringUtil.getNVLNULL(request.getParameter("systemid"));         //�ý���ID
	String strBusinessid = StringUtil.getNVLNULL(request.getParameter("businessid"));  //����ID
	String strDocid = StringUtil.getNVLNULL(request.getParameter("docid"));					//���繮��ID	
	String strLegacyin = StringUtil.getNVLNULL(request.getParameter("legacyin"));          //����1
	String strEvent = StringUtil.getNVLNULL(request.getParameter("event"));					//����2
	
	//strLegacyin = "<?xml version='1.0' encoding='euc-kr'?><������Ǽ�><�Ϲ�����><��ǥ��ȣ>100001</��ǥ��ȣ><ȸ������>2002-10-04</ȸ������><ȸ�������>xxxxxxx</ȸ�������><ǰ�Ǻμ�>xxxxxxx</ǰ�Ǻμ�></�Ϲ�����><�ݾ��׸�><�����ڵ�>xxxxxxxxx</�����ڵ�><�����>xx����</�����><���¹�ȣ>xxxxxxxxxx</���¹�ȣ><������>ȫ�浿</������><�뺯>xxxxxxx</�뺯></�ݾ��׸�><DOCSUBMIT><SUID>39aDFDDDF000DFESFESFEF</SUID></DOCSUBMIT></������Ǽ�>";
	
	//���ڰ��翡�� �ڵ带 XML String���� �Ѱ��ִµ� <SUID>�ڵ�</SUID>�� �κ��� �ڵ� ���� �����´�.
	if ( !strLegacyin.equals("")) {
		strLegacyin = nads.lib.reqsubmit.util.StringUtil.getCutString(strLegacyin, "<SUID>","</SUID>");
	}
	
	System.out.println("strSystemid : "+strSystemid);
	System.out.println("strBusinessid : "+strBusinessid);
	System.out.println("strDocid :"+strDocid);
	System.out.println("strLegacyin : "+strLegacyin);
	System.out.println("strEvent : "+strEvent);
	
	out.println("strSystemid :" + strSystemid + "<br>");
	out.println("strBusinessid :" + strBusinessid + "<br>");
	out.println("strDocid :" + strDocid + "<br>");
	out.println("strLegacyin :" + strLegacyin + "<br>");
	out.println("strEvent :" + strEvent + "<br>");
    
	String strRet = "";
	
	//Param ������ �� �Ѿ�Դ��� Ȯ���Ѵ�.
	if ( strSystemid == null || strSystemid.equals("")) {
		sFlag = false;
			System.out.println("9");
			out.println("9");
	} 
	if ( strBusinessid == null || strBusinessid.equals("")) {
		sFlag = false;
			System.out.println("8");
			out.println("8");
	} 
	if ( strDocid == null || strDocid.equals("")) {
		sFlag = false;
			System.out.println("7");
			out.println("7");
	}
	if ( strLegacyin == null || strLegacyin.equals("")) {
		sFlag = false;
			System.out.println("6");
			out.println("6");
	}
	if ( strEvent == null || strEvent.equals("")) {
		sFlag = false;
			System.out.println("5");
			out.println("5");
	}
	
    
	//###################################################
	//�̺κп��� �䱸���߼� UMS ó���ϴ� Delegate�� �߰��Ѵ�.             
	//�䱸�� �߼۽� EMS �Ǵ� SMS�� �߼� ���� ���·� ������                  
    //����Ϸ� ������ ���� �ʵ尪�� ���ۿ�û ���·� Update ����� �Ѵ�. 
    //����ݷ� ������ ���� �ش� ������ ���̺��� �����ؾ��Ѵ�.              
    //###################################################
    
	if (sFlag == true) {
		//###################################################
   	    //���繮����ȣ�� ó���Ѵ�.                                                                
        //###################################################
        
	    //Delegate ����
        UmsDelegate objUmsInfo = new  UmsDelegate();
        
        //*****************> update_ACUBE_NO  = SQL ����ؼ� ���ڰ����ȣ UPDATE
		//�Է��� ����Ÿ�� HashTable ����
		Hashtable objHashData = new Hashtable();
   	    int intResult = 0;
   	    String strAprvRslt = "001"; //���
		objHashData.put("APRV_DOC_NO", strDocid);     //�����ȣ
  		objHashData.put("APRV_RSLT", strAprvRslt);       //������
  		objHashData.put("OFFI_DOC_ID", strLegacyin);   //����ID
  		
  		
		try {
			intResult = objUmsInfo.update_ACUBE_NO(objHashData);
		} catch (AppException objAppEx) {
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
			return;
		}
		
		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
			out.println("���� ����<br>");
		}
         
	    System.out.println("1");
    	out.println("1");
        //###################################################
	    
		// �Ϸ�(���ڿ��� �Ǵ� SMS������ �����Ű�� update ������ ó���Ѵ�.)
		//if ( strEvent.equals("0x08") || strEvent.equals("0x20") || strEvent.equals("0x08")) {
		if ( strEvent.equals("8")) {
			
        	//���ڿ���, SMS ���������� ���ۿ�û���� ó��
   	   	    strAprvRslt = "002"; //�Ϸ�
   	   	    
            //*****************> update_TBDS_OFFICIAL_DOC_INFO      Param ������ ����ID(strLegacyin)�� �ѱ�� ������ ���̺��� ����Ϸ�� �ٲ۴�.
            //*****************> update_SMTP_SEND_STATUS     		Param ������ ����ID(strLegacyin)�� �ѱ��.
            //*****************> update_SMS_SEND_STATUS       		Param ������ ����ID(strLegacyin)�� �ѱ��.
        	System.out.println("2");
        	out.println("2");
		}
		
		// �ݷ�(���ڿ��� �Ǵ� SMS������ �����Ű�� delete ������ ó���Ѵ�.)
	    //if (strEvent.equals("0x10")) {
	    if (strEvent.equals("16")) {
        //�߽�����Table, ���ڿ���Table, SMSTable���� �߽�ID�� �ش��ϴ� ������ ����
   	   	    strAprvRslt = "003"; //�ݷ�
            //*****************> update_TBDS_OFFICIAL_DOC_INFO      Param ������ ����ID(strLegacyin)�� �ѱ�� ������ ���̺��� ����ݷ��� �ٲ۴�.
            //*****************> delete_SMTP_MAI     Param ������ ����ID(strLegacyin)�� �ѱ��.
		    //*****************> delete_SMTP_REC    Param ������ ����ID(strLegacyin)�� �ѱ��.
		    //*****************> Ʈ���ſ� �ɷ��ִ� ������ �����.
		    //*****************> delete_SMS              Param ������ ����ID(strLegacyin)�� �ѱ��.
  	        //*****************> delete_SEND_INFO   Param ������ ����ID(strLegacyin)�� �ѱ��.
  	        
			System.out.println("3");
			out.println("3");
	    }
	    
		// ��Ⱥ���(���ڿ��� �Ǵ� SMS������ �����Ű�� delete ������ ó���Ѵ�.)
	    if (strEvent.equals("����")) {
        //�߽�����Table, ���ڿ���Table, SMSTable���� �߽�ID�� �ش��ϴ� ������ ����
   	   	    strAprvRslt = "004"; //��Ⱥ���
            //*****************> update_TBDS_OFFICIAL_DOC_INFO      Param ������ ����ID(strLegacyin)�� �ѱ�� ������ ���̺��� �����Ⱥ����� �ٲ۴�.        
            objHashData.clear();            
	        objHashData.put("APRV_DOC_NO", strDocid);     //�����ȣ
	  		objHashData.put("APRV_RSLT", strAprvRslt);      //������
	  		objHashData.put("OFFI_DOC_ID", strLegacyin);  //����ID
	  		
			try {
				intResult = objUmsInfo.update_ACUBE_NO(objHashData);
			} catch (AppException objAppEx) {
			
				// ���� �߻� �޼��� �������� �̵��Ѵ�.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
				return;
			}
			
			out.print("intResult : " + intResult);
			
			if(intResult != 0 ){
				out.println("���� ����<br>");
			}
            
			System.out.println("4");
			out.println("4");
	    }
	}
	//###################################################
	 
	//���ڰ��翡 ����뺸
	if(sFlag == true){
	   strRet = "<?xml version='1.0' encoding='euc-kr'?>\n"+
	                   "<REPLY>"+
					   "<REPLY_CODE>1</REPLY_CODE>"+
					   "<DESCRIPTION>����</DESCRIPTION>"+
					   "</REPLY>";
	System.out.println("����");
	out.println("����");
	}
	else{
	   strRet = "<?xml version='1.0' encoding='euc-kr'?>\n"+
	                   "<REPLY>"+
					   "<REPLY_CODE>0</REPLY_CODE>"+
					   "<DESCRIPTION>����</DESCRIPTION>"+
					   "</REPLY>";
	System.out.println("����");
	out.println("����");
	}
	
	//out.println(strRet);
%>