<%-- 
    Document   : profile
    Created on : 24-Sep-2015, 13:30:50
    Author     : Tom
--%>
<%@page import="Stores.LoggedIn"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="Stores.UserStore"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <%
        UserStore profile = (UserStore) request.getAttribute("Profile");
        LoggedIn lg = (LoggedIn) session.getAttribute("LoggedIn");

        if (profile != null) { // user exists
            String username = profile.getUsername();
            String firstName = profile.getFirstname();
            String lastName = profile.getLastname();
            String matric = profile.getMatriculationNo();
            String email = profile.getEmail();
            String phoneNo = profile.getPhoneNo();
            char gender = profile.getGender();
            String country = profile.getCountry();
            String inst = profile.getInstitution();
            String subInst = profile.getInstitution();
            String degree = profile.getDegree();
            Timestamp dob = profile.getDob();
            String yos = profile.getYos();
            int status = profile.getUserStatus();
            
            int onlineTheory = profile.getOnlineTheory();
            int action = profile.getAction();
            int project = profile.getProject();
            int challenge = profile.getChallenge();
            int total = profile.getTotal();
            
            float[] points = {onlineTheory, action, project, challenge};
            java.util.Arrays.sort(points);

            float silverMedalPoints = 70;
            float goldMedalPoints = silverMedalPoints * 2f;
            
            int highestPercent = Math.round((points[3] / goldMedalPoints) * 100);
            int nextHighestPercent = Math.round((points[2] / goldMedalPoints) * 100);
            
            int onlinePercent = Math.round((onlineTheory / silverMedalPoints) * 100);
            int actionPercent = Math.round((action / silverMedalPoints) * 100);
            int projectPercent = Math.round((project / silverMedalPoints) * 100);
            int challengePercent = Math.round((challenge / silverMedalPoints) * 100);
    %>
        <title><%=firstName%> <%=lastName%>'s Profile</title>
    </head>
    <body>
        <h1><%=firstName%> <%=lastName%></h1>
        <h4><%=username%></h4>
        
        <div class="container">
            <h2>Progress to Gold (2 Silver Medals)</h2>
            <div class="progress">
                <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="<%=highestPercent%>" aria-valuemin="0" aria-valuemax="<%=goldMedalPoints%>" style="width:<%=highestPercent%>%; min-width: 2em">
                  <%=highestPercent%>%
                </div>
                <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="<%=nextHighestPercent%>" aria-valuemin="0" aria-valuemax="<%=goldMedalPoints%>" style="width:<%=nextHighestPercent%>%; min-width: 2em">
                  <%=nextHighestPercent%>%
                </div>
            </div>
            
            <br>
            
            <h2>Progress to Silver (70 pts)</h2>
            <h3>Online Theory - <%=onlineTheory%> pts</h3>
            <div class="progress">
                <div class="progress-bar" role="progressbar" aria-valuenow="<%=onlineTheory%>" aria-valuemin="0" aria-valuemax="<%=silverMedalPoints%>" style="width:<%=onlinePercent%>%; min-width: 2em">
                  <%=onlinePercent%>%
                </div>
            </div>
                
            <h3>Action - <%=action%> pts</h3>
            <div class="progress">
                <div class="progress-bar" role="progressbar" aria-valuenow="<%=action%>" aria-valuemin="0" aria-valuemax="<%=silverMedalPoints%>" style="width:<%=actionPercent%>%; min-width: 2em">
                  <%=actionPercent%>%
                </div>
            </div>
                
            <h3>Project - <%=project%> pts</h3>
            <div class="progress">
                <div class="progress-bar" role="progressbar" aria-valuenow="<%=project%>" aria-valuemin="0" aria-valuemax="<%=silverMedalPoints%>" style="width:<%=projectPercent%>%; min-width: 2em">
                  <%=projectPercent%>%
                </div>
            </div>
                
            <h3>Challenge - <%=challenge%> pts</h3>
            <div class="progress">
                <div class="progress-bar" role="progressbar" aria-valuenow="<%=challenge%>" aria-valuemin="0" aria-valuemax="<%=silverMedalPoints%>" style="width:<%=challengePercent%>%; min-width: 2em">
                  <%=challengePercent%>%
                </div>
            </div>
            
            <h2>Total: <%=total%> pts</h2>
        </div>
    </body>
    <%
        } else {
    %>
        <title>Profile not found</title>
    </head>
    <body>
        <h1>User does not exist!</h1>
    </body>
    <%
        }
    %>
</html>
