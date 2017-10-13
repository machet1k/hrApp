<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Добавление нового кандидата</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link href="css/groundwork.css" type="text/css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="icon" type="image/x-icon" href="http://savepic.ru/14659608.png"/>
        <!--script src="../../js/jquery-3.2.1.js"></script>
        <script src="../../js/jquery-maskedinput.js"></script>
        
        <script src="http://base.4cars.pro/jquery.maskedinput.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script-->

        <script>
            var СанктПетербург = Array('HeadHunter', 'SuperJob', 'Avito', 'Сайт Грузовичкоф', 'Сайт Таксовичкоф', 'Сайт БизнесФон', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят');
            var Димитровград = СанктПетербург.concat(Array('trisosny.ru', '25kanal.ru', 'dimitrovgradros.flagma.ru'));
            var Асбест = СанктПетербург.concat(Array('maxz.ru', 'asbest-gid.ru', 'asbest.name', 'asbet.ru', 'asbest-online.ru'));
            var Рефтинский = СанктПетербург.concat(Array('reftinskiy.ru', 'reftnews.ru'));
            var Челябинск = СанктПетербург.concat(Array('74.ru', 'chel.barahla.net', 'ubu.ru/chelyabinsk', 'chelyabinsk.gde.ru', 'chelyabinsk.dorus.ru', 'chelyabinsk.bestru.ru', 'chelyabinsk.sopta.ru'));
            var ДО = СанктПетербург.concat(Array('HeadHunter', 'SuperJob', 'Avito', 'Сайт Грузовичкоф', 'Сайт Таксовичкоф', 'Сайт БизнесФон', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят'));

            function showAdv(v) {
                var mas = eval(v);
                var el = document.getElementById('adv');
                while (el.childNodes.length > 0) {
                    el.removeChild(el.childNodes[el.childNodes.length - 1]);
                }
                for (var i = 0; i < mas.length; i++) {
                    var opt = document.createElement("option");
                    opt.innerHTML = mas[i];
                    el.appendChild(opt);
                }
            }

        </script>

    </head>
    <body onload="showAdv('СанктПетербург')">
        
        <a href="http://biznesfon.ru"><img class="logimg" src="https://s8.hostingkartinok.com/uploads/images/2017/10/96bfde63dbe76ee39596a1cbed77c3bb.png" alt="logotype"></a>
        <div class="animated fadeInDownBig">
            <div class="headertext">
                <%
                    String displayDate = LocalDate.parse(String.valueOf(session.getAttribute("dates")), DateTimeFormatter.ofPattern("yyyy-MM-dd")).format(DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru")));
                    out.print("Добавление нового кандидата на " + displayDate + " к " + session.getAttribute("times"));
                %>
            </div>
            <div class="one sevenths centered triple-padded">    
                <form action="/hr/add/adding">
                    <input required class="gap-bottom" type="text" name="surname" placeholder="Фамилия">
                    <input required class="gap-bottom" type="text" name="name" placeholder="Имя">
                    <input required class="gap-bottom" type="text" name="patronymic" placeholder="Отчество">
                    <input required class="gap-bottom" aria-required="true" type="text" name="phonenumber" placeholder="9115557799" pattern="[9]{1}[0-9]{9}" >
                    <input required class="gap-bottom" aria-required="true" type="email" name="email" placeholder="operator@gmail.com">

                    <select class="gap-bottom" name="project" required>
                        <option selected disabled value=''>Проект</option>
                        <option>Грузовичкоф</option>
                        <option>Таксовичкоф</option>
                        <option>Достаевский</option>
                        <option>Кисточки</option>
                    </select>    

                    <select class="gap-bottom" name="branch" required onchange="showAdv(this.value)">
                        <option selected disabled value=''>Площадка</option>
                        <option value='СанктПетербург'>Санкт-Петербург</option>
                        <option value='Димитровград'>Димитровград</option>
                        <option value='Рефтинский'>Рефтинский</option>
                        <option value='Асбест'>Асбест</option>
                        <option value='Челябинск'>Челябинск</option>
                        <option value='ДО'>Домашний оператор</option>
                    </select>

                    <select class="gap-bottom" name="channel" required>
                        <option selected disabled value=''>Канал связи</option>
                        <option title="Исходящий(отклик)">Исх.отклик</option>
                        <option title="Исходящий(холодный звонок)">Исх.хол.зв.</option>
                        <option title="Входящий">Входящий</option>
                    </select> 

                    <select class="gap-bottom" name="advertising" required id="adv">
                        <option selected disabled value=''>Рекламный источник</option>
                    </select> 

                    <button class="pull-left btn-success">Добавить</button>
                </form>    
                <form action="/hr">
                    <button class="pull-right btn-danger">Отмена</button>
                </form>  
            </div>
        </div>
    </body>
</html>