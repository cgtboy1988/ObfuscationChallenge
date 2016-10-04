<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%@include file="./WEB-INF/includes/includes.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Tigress</title>

</head>

<body>
<%@include file="./WEB-INF/includes/mainPane.jsp" %>
<table id="inner_content">
	<tr>
    	<td colspan="3" class="no_bottom_padding">
    	<div align="center">
    	<table id="page_title_table_row">
    	<tr>
    	<td>
        <div align="center" id="inner_content_title">
        <%
        
        if(verbose)
        {
        	System.out.println("Got to hasUser conditional");
        }
		if(!hasUser)
		{
		%>
        Welcome to the Tigress Challenge Engine
        <%
		}
		else
		{
		%>
        Welcome back, <% out.print(displayName); %>!
        <%
		}
		%>
        </div>
        <div align="center" id="inner_content_slogan">
        Obfuscation Made Easy</div>
        </td>
        </tr>
        </table>
        </div>
        </td>
    </tr>
	<tr>
    	<td width="25%">
        <table class="inner_content_table">
        <tr>
        <td>
        <div align="center">
        <%
        if(!hasUser)
        {
        	%>
        	<meta http-equiv="refresh" content="0; url=index.jsp" />
        	<%
        }
        else
        {
	        ArrayList myChallengesFull = myConnector.getChallenge((String)request.getParameter("challengeName"), (String)myUser.getAttribute("email"));
	        ArrayList myChallenges = new ArrayList();
	        myChallenges.add(myChallengesFull.get(0));
	        if(verbose)
	        {
	        	System.out.println(myChallenges);
	        }
	        DBObj descriptor = (DBObj)myChallenges.get(0);
	        ArrayList keys = descriptor.getAttributeNames();
	        ConcurrentHashMap translationMap = new ConcurrentHashMap();
	        translationMap.put("admin_email", "Instructor");
	        translationMap.put("challenge_name", "Challenge");
	        translationMap.put("open_time", "Open");
	        translationMap.put("end_time", "Close");
	        translationMap.put("grade", "Grade");
	        for(int x=0; x<keys.size(); x++)
	        {
	        	String tmp=(String)keys.get(x);
	        	if(tmp.equals("email") || tmp.equals("code_generated") || tmp.equals("end_time") || tmp.equals("open_time") || tmp.equals("description") || tmp.equals("command") || tmp.equals("command_order") || tmp.equals("originalFile") || tmp.equals("obfuscatedFile") || tmp.equals("submittedFile") || tmp.equals("submissionTime") || tmp.equals("submittedWrittenFile") || tmp.equals("commandName"))
	        	{
	        		keys.remove(x);
	        		x--;
	        	}
	        }
	        keys.add("open_time");
	        keys.add("end_time");
        	if((Integer)((DBObj)myChallenges.get(0)).getAttribute("code_generated") == 0)
        	{
        %>
        <a href="generateCode.jsp?challengeName=<%= ((DBObj)myChallenges.get(0)).getAttribute("challenge_name") %>">
        Generate Obfuscated Code
        </a>
        <%
        	}
        	else
        	{
        %>
        <br />
        <a href="ChallengeObfuscatedFileServer?challengeName=<%= ((DBObj)myChallenges.get(0)).getAttribute("challenge_name") %>">
        Download Obfuscated Code
        </a>
        <br />
        <br />
        </div>
        </td>
        </tr>
        <tr>
        <td>
        <form action="ChallengeDeobfuscatedSubmissionServlet" method="post" enctype="multipart/form-data">
        <div align="center">
        <br />
        Code
        <br />
        <input type="file" name="codeFile" size="50" />
        <br />
        <br />
        Write-up
        <br />
        <input type="file" name="writeFile" size="50" />
        <br />
        <br />
        <input type="hidden" name="challengeName" value="<%= ((DBObj)myChallenges.get(0)).getAttribute("challenge_name") %>" />
        <input type="submit" value="Submit Deobfuscated Code" />
        <br />
        <br />
        <%
        if(((DBObj)myChallenges.get(0)).getAttribute("submissionTime")!=null)
        {
        %>
        Last submission made on: <%= ((DBObj)myChallenges.get(0)).getAttribute("submissionTime") %>
        <br />
        <br />
        <%
        }
        %>
        </div>
        </form>
        <%
        	}
        %>
        </td>
        </tr>
        </table>
        </td>
        <td width="50%">
        <table class="inner_content_table">
        <tr>
        <td>
        <table class="news_table" width="100%">
        <tr class="title_general">
        <td colspan="3" align="center">
        Challenges
        </td>
    	</tr>
        <tr colspan="3" width="100%:">
        <td>
        <table class="news_item_table" width="100%">
        <tr>
        <%
        for(int x=0; x<keys.size(); x++)
        {
        %>
        <td width="<% out.print(100/(double)keys.size()); %>%">
        <div align="center">
        <b>
        <%
        	if(translationMap.containsKey(keys.get(x)))
        	{
        		out.print(translationMap.get(keys.get(x)));
        	}
        	else
        	{
        		out.print(keys.get(x));
        	}
        %>
        </b>
        </div>
        </td>
        <%
        }
        %>
        </tr>
        <%
        for(int x=0; x<myChallenges.size(); x++)
        {
        %>
        <tr>
	        <%
	        for(int y=0; y<keys.size(); y++)
	        {
	        %>
	        <td width="<% out.print(100/(double)keys.size()); %>%">
	        <div align="center">
	        <%
	        	if(keys.get(y).equals("open"))
	        	{
	        		out.print((((Integer)((DBObj)myChallenges.get(x)).getAttribute(keys.get(y)))==1) ? "Yes" : "No");
	        	}
	        	else if(keys.get(y).equals("challenge_name"))
	        	{
	        		
	        		out.print(((DBObj)myChallenges.get(x)).getAttribute(keys.get(y)));
	        		
	        	}
	        	else
	        	{
	        		out.print(((DBObj)myChallenges.get(x)).getAttribute(keys.get(y)));
	        	}
	        %>
	        </div>
	        </td>
	        <%
	        }
	        %>
        </tr>
        <tr>
        <td colspan=<%= keys.size() %>>
        <%
        out.print(((DBObj)myChallenges.get(x)).getAttribute("description"));
        %>
        </td>
        </tr>
        <%
        }
        }
        %>
        </table>
        </td>
        </tr>
        </table>
        </td>
        </tr>
        </table>
        </td>
        <td width="25%">
        <table class="inner_content_table">
        <tr>
        <td>
        <%
        if(verbose)
        {
        	System.out.println("Got to hasUser conditional");
        }
		if(!hasUser)
		{
		%>
        	<table class="news_table" width="100%">
            <tr class="title_general">
            <td>
        	<div align="center">Login<br /></div>
            </td>
            </tr>
            </table>
            <table class="news_item_table" width="100%">
            <tr>
            <td>
        	<%@include file="./WEB-INF/includes/loginWindow.jsp" %>
            </td>
            </tr>
            </table>
        <%
		}
		else
		{
		%>
        	<table class="news_table" width="100%">
            <tr class="title_general">
            <td>
        	<div align="center">Logout<br /></div>
            </td>
            </tr>
            </table>
        	<table class="news_item_table" width="100%">
            <tr>
            <td>
        	<div align="center">Hi there, <%=displayName %>! Your last visit was <%
				java.util.Date logonDate=(java.util.Date)myUser.getAttribute("previousVisit");
				out.print(dateFormat.format(logonDate));
				%>.<br />Not you?<br /></div>
            <%@include file="./WEB-INF/includes/logoutWindow.jsp" %>
            </td>
            </tr>
            </table>
        <%
		}
		if(verbose)
        {
        	System.out.println("Got past hasUser conditional");
        }
		%>
        </td>
        </tr>
        </table>
        </td>
    </tr>
</table>
<%@include file="./WEB-INF/includes/footer.jsp" %>
</body>

</html>