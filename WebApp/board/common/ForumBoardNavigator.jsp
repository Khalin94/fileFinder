<%
	String strBbrdKindNm = "";
	
	if(strBbrdKind.equals(noticeBoard) || strBbrdKind.equals(allNoticeBoard)){
		strBbrdKindNm = "��������";
	} else if(strBbrdKind.equals(freeBoard) || strBbrdKind.equals(allFreeBoard)){
		strBbrdKindNm = "�����Խ���";
	} else if(strBbrdKind.equals(dataBoard)){
		strBbrdKindNm = "�ڷ��";
	} else if(strBbrdKind.equals(qnaBoard)){
		strBbrdKindNm = "���� ���ϱ�";
	} else if(strBbrdKind.equals(reportBoard)){
		strBbrdKindNm = "�����ڷ�";
	}
	
%>