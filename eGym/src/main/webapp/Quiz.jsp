<%-- 
    Document   : Quiz
    Created on : 24-Sep-2015, 10:30:42
    Author     : Dreads
--%>

<%@page import="Stores.LoggedIn"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="Stores.QuestionStore"%>
<%@page import="java.util.LinkedList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp"></jsp:include>
    <link href="css/style.css" rel="stylesheet" />  
    <%
    LinkedList<QuestionStore> questionList = (LinkedList<QuestionStore>) request.getAttribute("QuestionList");
    Iterator<QuestionStore> iterator;
    iterator = questionList.iterator();
    
    int quizId = 0;
    String Username = (String) request.getAttribute("userName");
            
    ArrayList<String> Questions = new ArrayList<String>();
    ArrayList<String> Answer1 = new ArrayList<String>();
    ArrayList<String> Answer2 = new ArrayList<String>();
    ArrayList<String> Answer3 = new ArrayList<String>();
    ArrayList<String> Answer4 = new ArrayList<String>();
    ArrayList<Integer> CorrectAnswer = new ArrayList<Integer>();
    while(iterator.hasNext())
    {
        QuestionStore qm = (QuestionStore) iterator.next();
        quizId = qm.getQuizId();
        Questions.add(qm.getQuestionBody());
        Answer1.add(qm.getAnswer1());
        Answer2.add(qm.getAnswer2());
        Answer3.add(qm.getAnswer3());
        Answer4.add(qm.getAnswer4());
        CorrectAnswer.add(qm.getCorrectAnswer());
    }

%>

        <script type="text/javascript">
            var pos = 0, quiz, quiz_status, question, userAnswer, posAnswers, ans1, ans2, ans3, ans4, correct = 0;
            var percentPass = 80;
            var questions = [];
            var answer1 = [];
            var answer2 = [];
            var answer3 = [];
            var answer4 = [];
            var stopped = false;
            var correctAnswer = [];
            <%  
                for(int i=0; i<Questions.size(); i++)
                {%>
                   questions.push("<%=Questions.get(i)%>");
                   answer1.push("<%=Answer1.get(i)%>");
                   answer2.push("<%=Answer2.get(i)%>");
                   answer3.push("<%=Answer3.get(i)%>");
                   answer4.push("<%=Answer4.get(i)%>");
                   correctAnswer.push("<%=CorrectAnswer.get(i)%>");
                <%}
            %>
            function _(x)
            {
                    return document.getElementById(x);
            }
            function startQuiz()
            {
                    quiz = _("quiz");
                    document.getElementById("timer").innerHTML = "10:00";
                    quiz.innerHTML = "<h2>Click to Start!</h2>";
                    quiz.innerHTML += "<button onclick='initQuiz()'>Start Quiz</button>";
            }
            function startTimer()
            {
                stopped = false;
                var mins = 9;
                var sec = 60;
                setInterval(function()
                {
                    if(stopped === false)
                    {
                        sec--;
                        document.getElementById("timer").innerHTML = mins +":" + sec ;
                        if(sec === 00)
                        {
                            if (mins === 0)
                            {
                                document.getElementById("timer").innerHTML = mins +" : " + sec ;
                                stopped = true;
                                pos = (questions.length) + 1;
                                renderQuestion();
                            }else{
                                mins--;
                                sec = 60;
                            }
                        }
                    }
                 },1000);
            }
            function renderQuestion()
            {
                if(pos >= questions.length)
                {
                    stopped = true;
                    var noCorrect = "You got " + correct + " of " + questions.length + " questions correct!";
                    var percent = ((correct / questions.length) * 100);
                    var perCorr = "You got " + percent + "% correct!";
                    
                    if(percent >= percentPass)
                    {
                        document.getElementById('UserScore').value = percent;
                        alert("Congradulations! YOU PASSED!" + "\n" + noCorrect + "\n" + perCorr);
                        $('.yourButtonClassName').show();
                        $('.SubmitButton').hide();
                        alert("Click on the return button to finish the test.");
                    }
                    else
                    {
                        document.getElementById('UserScore').value = percent;
                        alert("Unfortuently, you need 80% to pass! \n" + noCorrect + "\n" + perCorr);
                        $('.yourButtonClassName').show();
                        $('.SubmitButton').hide();
                        alert("Click on the return button to finish the test.");
                    }
                    _("quiz_status").innerHTML = "Quiz Completed";

                    pos = 0;
                    correct = 0;
                    return false;
                }
                _("quiz_status").innerHTML = "Question " + (pos+1) + " of "+questions.length;
                question = questions[pos];
                ans1 = answer1[pos];
                ans2 = answer2[pos];
                ans3 = answer3[pos];
                ans4 = answer4[pos];
                quiz.innerHTML = "<h4>" + question + "</h4>";
                quiz.innerHTML += "<input type='radio' name='posAnswers' value='1'> " + ans1 + "<br>";
                quiz.innerHTML += "<input type='radio' name='posAnswers' value='2'> " + ans2 + "<br>";
                quiz.innerHTML += "<input type='radio' name='posAnswers' value='3'> " + ans3 + "<br>";
                quiz.innerHTML += "<input type='radio' name='posAnswers' value='4'> " + ans4 + "<br><br>";
                quiz.innerHTML += "<button class='SubmitButton' onclick='checkAnswer()'>Submit</button>";
            }
            function checkAnswer()
            {
                    posAnswers = document.getElementsByName("posAnswers");
                    for(var i=0; i<posAnswers.length; i++)
                    {
                        if(posAnswers[i].checked)
                        {
                            userAnswer = posAnswers[i].value;
                        }
                    }
                    if(userAnswer === correctAnswer[pos])
                    {
                        correct++;
                    }
                    pos++;
                    renderQuestion();
            }
            function initQuiz()
            {
                pos = 0;
                startTimer();
                renderQuestion();
            }
            window.addEventListener("load", startQuiz, false);
	</script>
<div id="services" class="pad-section">
    
    <div class="container">   
    <%
        LoggedIn lg = (LoggedIn) session.getAttribute("LoggedIn");
        if (lg != null && lg.isLoggedIn()) {      
    %>
    
            <div>
                <h3>Time Left: <span id="timer"><span></h3>
            </div>
            <div>
                <h2 id="quiz_status"></h2>
                <div id="quiz"></div>
            </div>
            <div>
                <form action="/eGym/updateQuizAttempts" method="POST">
                    <input id="QuizId" name="QuizId" type="hidden" value="<%=quizId%>" />
                    <input id="Username" name="Username" type="hidden" value="<%=Username%>" />
                    <input id="UserScore" name="UserScore" type="hidden" value="" />
                    <button type="submit" class='yourButtonClassName' style='display:none' value="updateQuizAttempts">Finish Test</button>
                </form>
            </div>
    <%
        }else{
    %>
            <h2>Please <a href="<%=response.encodeURL("login.jsp")%>">sign in</a></h2>
    <%
        }     
    %>
    </div>
    </div>
<jsp:include page="footer.jsp"></jsp:include>