<%
	String strBbrdKindNm = "";
	
	if(strBbrdKind.equals(noticeBoard) || strBbrdKind.equals(allNoticeBoard)){
		strBbrdKindNm = "공지사항";
	} else if(strBbrdKind.equals(freeBoard) || strBbrdKind.equals(allFreeBoard)){
		strBbrdKindNm = "자유게시판";
	} else if(strBbrdKind.equals(dataBoard)){
		strBbrdKindNm = "자료실";
	} else if(strBbrdKind.equals(qnaBoard)){
		strBbrdKindNm = "묻고 답하기";
	} else if(strBbrdKind.equals(reportBoard)){
		strBbrdKindNm = "보도자료";
	}
	
%>