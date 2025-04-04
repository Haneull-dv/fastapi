-- 001. 전체 축구팀 목록을 팀이름 오름차순으로 출력하시오
SELECT team_name FROM team ORDER BY team_name ASC;



-- 002. 플레이어의 포지션 종류를 나열하시오. 단 중복은 제거하고, 포지션이 없으면 빈공간으로 두시오
SELECT DISTINCT position FROM player WHERE position IS NOT NULL;


-- 003. 플레이어의 포지션 종류를 나열하시오. 단 중복은 제거하고, 포지션이 없으면 '신입' 으로 기재하시오
SELECT DISTINCT CASE WHEN position IS NULL THEN '신입' ELSE position END AS position FROM player;


-- 004. 수원팀에서 골키퍼(GK)의 이름을 모두 출력하시오. 단 수원팀 ID는 K02 입니다.
SELECT player_name FROM player WHERE team_id = 'K02' AND position = 'GK';



-- 005. 수원팀에서 성이 고씨이고 키가 170 이상인 선수를 출력하시오. 단 수원팀 ID는 K02 입니다.
SELECT player_name FROM player WHERE team_id = 'K02' AND player_name LIKE '고%' AND height >= 170;


-- 005-1. 수원팀의 ID 는 ?
SELECT team_id FROM team WHERE team_name = '수원';

-- 005-2. 수원팀에서 성이 고씨이고 키가 170 이상인 선수를 출력하시오. (서브쿼리)
SELECT player_name FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '수원') AND last_name = '고' AND height >= 170;


-- 006
-- 다음 조건을 만족하는 선수명단을 출력하시오
-- 소속팀이 삼성블루윙즈이거나 
-- 드래곤즈에 소속된 선수들이어야 하고, 
-- 포지션이 미드필더(MF:Midfielder)이어야 한다. 
-- 키는 170 센티미터 이상이고 180 이하여야 한다.

SELECT player_name FROM player WHERE team_id IN ('K01', 'K02') AND position = 'MF' AND height >= 170 AND height <= 180;     

-- 첫번째 단계, id를 알았을 경우 진행해 봄
SELECT team_id FROM team WHERE team_name IN ('삼성블루윙즈', '드래곤즈');

-- 서브쿼리
SELECT player_name FROM player WHERE team_id IN (SELECT team_id FROM team WHERE team_name IN ('삼성블루윙즈', '드래곤즈')) AND position = 'MF' AND height >= 170 AND height <= 180;         

-- 인라인뷰
SELECT player_name FROM player WHERE team_id IN (SELECT team_id FROM team WHERE team_name IN ('삼성블루윙즈', '드래곤즈')) AND position = 'MF' AND height >= 170 AND height <= 180;         
    
-- 007
-- 수원을 연고지로 하는 골키퍼는 누구인가?

SELECT player_name FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '수원') AND position = 'GK';


-- 008
-- 서울팀 선수들 이름, 키, 몸무게 목록으로 출력하시오
-- 키와 몸무게가 없으면 "0" 으로 표시하시오
-- 키와 몸무게는 내림차순으로 정렬하시오

SELECT player_name, height, weight FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '서울') AND height IS NOT NULL AND weight IS NOT NULL ORDER BY height DESC, weight DESC; 


-- 009
-- 서울팀 선수들 이름과 포지션과
-- 키(cm표시)와 몸무게(kg표시)와  각 선수의 BMI지수를 출력하시오
-- 단, 키와 몸무게가 없으면 "0" 표시하시오
-- BMI는 "NONE" 으로 표시하시오(as bmi)
-- 최종 결과는 이름내림차순으로 정렬하시오

SELECT player_name, position, height, weight, CASE WHEN height IS NULL OR weight IS NULL THEN '0' ELSE ROUND(weight / (height * height) * 10000, 2) END AS bmi FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '서울') ORDER BY player_name DESC;





-- 010
-- STADIUM 에 등록된 운동장 중에서
-- 홈팀이 없는 경기장까지 전부 나오도록
-- 카운트 값은 19
-- 힌트 : LEFT JOIN 사용해야함

SELECT COUNT(*) FROM stadium LEFT JOIN schedule ON stadium.stadium_id = schedule.stadium_id WHERE schedule.home_team_id IS NULL;

-- 011
-- 팀과 연고지를 연결해서 출력하시오
-- [팀 명]             [홈구장]
-- 수원[ ]삼성블루윙즈 수원월드컵경기장

SELECT team_name, stadium_name FROM team LEFT JOIN stadium ON team.stadium_id = stadium.stadium_id;


-- 012
-- 수원팀 과 대전팀 선수들 중
-- 키가 180 이상 183 이하인 선수들
-- 키, 팀명, 사람명 오름차순

-- 해결방식 1 (조인 방식)
SELECT player_name, height, team_name FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE height >= 180 AND height <= 183 ORDER BY height ASC;


-- 해결방식 1-1 (뷰 생성 방식)
CREATE VIEW player_view AS SELECT player_name, height, team_name FROM player LEFT JOIN team ON player.team_id = team.team_id;


-- 해결방식 2 (인라인뷰 방식)
SELECT player_name, height, team_name FROM (SELECT player_name, height, team_name FROM player LEFT JOIN team ON player.team_id = team.team_id) WHERE height >= 180 AND height <= 183 ORDER BY height ASC;


-- 서브쿼리 내용 확인
SELECT * FROM player_view;


-- 013
-- 모든 선수들 중 포지션을 배정 받지 못한 선수들의 
-- 팀명과 선수이름 출력 둘다 오름차순

SELECT team_name, player_name FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE position IS NULL ORDER BY team_name ASC, player_name ASC;

-- 014
-- 팀과 스타디움, 스케줄을 조인하여
-- 2012년 3월 17일에 열린 각 경기의
-- 팀이름, 스타디움, 어웨이팀 이름 출력
-- 다중테이블 join 을 찾아서 해결하시오.

SELECT team_name, stadium_name, opponent_team_name FROM team LEFT JOIN schedule ON team.team_id = schedule.home_team_id LEFT JOIN stadium ON schedule.stadium_id = stadium.stadium_id LEFT JOIN team AS opponent ON schedule.opponent_team_id = opponent.team_id WHERE schedule.game_date = '2012-03-17';

-- 015 
-- 2012년 3월 17일 경기에
-- 포항 스틸러스 소속 골키퍼(GK)
-- 선수, 포지션,팀명 (연고지포함),
-- 스타디움, 경기날짜를 구하시오
-- 연고지와 팀이름은 간격을 띄우시오(수원[]삼성블루윙즈)

SELECT player_name, position, team_name, stadium_name, game_date FROM player LEFT JOIN team ON player.team_id = team.team_id LEFT JOIN schedule ON player.team_id = schedule.home_team_id LEFT JOIN stadium ON schedule.stadium_id = stadium.stadium_id WHERE team_name = '포항 스틸러스' AND position = 'GK' AND game_date = '2012-03-17';

-- 016 
-- 홈팀이 3점이상 차이로 승리한 경기의
-- 경기장 이름, 경기 일정
-- 홈팀 이름과 원정팀 이름을
-- 구하시오

SELECT stadium_name, game_date, home_team_name, opponent_team_name FROM schedule LEFT JOIN stadium ON schedule.stadium_id = stadium.stadium_id LEFT JOIN team AS home ON schedule.home_team_id = home.team_id LEFT JOIN team AS opponent ON schedule.opponent_team_id = opponent.team_id WHERE home_score - opponent_score >= 3;

-- 017
-- 다음 조건을 만족하는 선수명단을 출력하시오
-- 소속팀이 삼성블루윙즈이거나 
-- 드래곤즈에 소속된 선수들이어야 하고, 
-- 포지션이 미드필더(MF:Midfielder)이어야 한다. 
-- 키는 170 센티미터 이상이고 180 이하여야 한다.

SELECT player_name, position, team_name, height FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE team_name IN ('삼성블루윙즈', '드래곤즈') AND position = 'MF' AND height >= 170 AND height <= 180;

-- 018
-- 다음 조건을 만족하는 선수명단을 출력하시오
-- 소속팀이 삼성블루윙즈이거나
-- 드래곤즈에 소속된 선수들이어야 하고,
-- 포지션이 미드필더(MF:Midfielder)이어야 한다.
-- 키는 170 센티미터 이상이고 180 이하여야 한다.

SELECT player_name, position, team_name, height FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE team_name IN ('삼성블루윙즈', '드래곤즈') AND position = 'MF' AND height >= 170 AND height <= 180;

-- 019
-- 전체 축구팀의 목록을 출력하시오
-- 단, 팀명을 오름차순으로 정렬하시오.

SELECT team_name FROM team ORDER BY team_name ASC;

-- 020
-- 포지션의 종류를 모두 출력하시오
-- 단, 중복은 제거합니다.

SELECT DISTINCT position FROM player WHERE position IS NOT NULL;

-- 021
-- 포지션의 종류를 모두 출력하시오
-- 단, 중복은 제거합니다.
-- 포지션이 없으면 신입으로 기재

SELECT DISTINCT CASE WHEN position IS NULL THEN '신입' ELSE position END AS position FROM player;

-- 022
-- 수원을 연고지로 하는팀의 골키퍼는
-- 누구인가 ?

SELECT player_name FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '수원') AND position = 'GK';

-- 023
-- 수원 연고팀에서 키가 170 이상 선수
-- 이면서 성이 고씨인 선수는 누구인가

SELECT player_name FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '수원') AND height >= 170 AND last_name = '고';

-- 024
-- 광주팀 선수들 이름과
-- 키와 몸무게 목록을 출력하시오
-- 키와 몸무게가 없으면 "0" 표시하시오
-- 키와 몸무게는  내림차순으로 정렬하시오

SELECT player_name, height, weight FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '광주') AND height IS NOT NULL AND weight IS NOT NULL ORDER BY height DESC, weight DESC;

-- 025
-- 서울팀 선수들 이름과 포지션과
-- 키(cm표시)와 몸무게(kg표시)와  각 선수의 BMI지수를 출력하시오
-- 단, 키와 몸무게가 없으면 "0" 표시하시오
-- BMI는 "NONE" 으로 표시하시오(as bmi)
-- 최종 결과는 이름내림차순으로 정렬하시오

SELECT player_name, position, height, weight, CASE WHEN height IS NULL OR weight IS NULL THEN '0' ELSE ROUND(weight / (height * height) * 10000, 2) END AS bmi FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '서울') ORDER BY player_name DESC;

-- 026
-- 4개의 테이블의 키값을 가지는 가상 테이블을 생성하시오 (join)

CREATE VIEW player_view AS SELECT player_name, position, height, weight, CASE WHEN height IS NULL OR weight IS NULL THEN '0' ELSE ROUND(weight / (height * height) * 10000, 2) END AS bmi FROM player WHERE team_id = (SELECT team_id FROM team WHERE team_name = '서울') ORDER BY player_name DESC;

-- 027
-- 수원팀(K02) 과 대전팀(K10) 선수들 중 포지션이 골키퍼(GK) 인
-- 선수를 출력하시오
-- 단 , 팀명, 선수명 오름차순 정렬하시오

SELECT player_name, team_name FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE team_id IN ('K02', 'K10') AND position = 'GK' ORDER BY team_name ASC, player_name ASC;

-- 028
-- 팀과 연고지를 연결해서 출력하시오
-- [팀 명]             [홈구장]
-- 수원[ ]삼성블루윙즈 수원월드컵경기장

SELECT team_name, stadium_name FROM team LEFT JOIN stadium ON team.stadium_id = stadium.stadium_id;

-- 029
-- 수원팀(K02) 과 대전팀(K10) 선수들 중
-- 키가 180 이상 183 이하인 선수들
-- 키, 팀명, 사람명 오름차순 (편집됨) 

SELECT player_name, height, team_name FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE height >= 180 AND height <= 183 ORDER BY height ASC;

-- 030
-- 모든 선수들 중 포지션을 배정 받지 못한 선수들의
-- 팀명과 선수이름 출력 둘다 오름차순

SELECT team_name, player_name FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE position IS NULL ORDER BY team_name ASC, player_name ASC;

-- 031
-- 팀과 스타디움, 스케줄을 조인하여
-- 2012년 3월 17일에 열린 각 경기의
-- 팀이름, 스타디움, 어웨이팀 이름 출력
-- 다중테이블 join 을 찾아서 해결하시오.

SELECT team_name, stadium_name, opponent_team_name FROM team LEFT JOIN schedule ON team.team_id = schedule.home_team_id LEFT JOIN stadium ON schedule.stadium_id = stadium.stadium_id LEFT JOIN team AS opponent ON schedule.opponent_team_id = opponent.team_id WHERE schedule.game_date = '2012-03-17';

-- 032
-- 2012년 3월 17일 경기에
-- 포항 스틸러스 소속 골키퍼(GK)
-- 선수, 포지션,팀명 (연고지포함),
-- 스타디움, 경기날짜를 구하시오
-- 연고지와 팀이름은 간격을 띄우시오(수원[]삼성블루윙즈)

SELECT player_name, position, team_name, stadium_name, game_date FROM player LEFT JOIN team ON player.team_id = team.team_id LEFT JOIN schedule ON player.team_id = schedule.home_team_id LEFT JOIN stadium ON schedule.stadium_id = stadium.stadium_id WHERE team_name = '포항 스틸러스' AND position = 'GK' AND game_date = '2012-03-17';

-- 033
-- 홈팀이 3점이상 차이로 승리한 경기의
-- 경기장 이름, 경기 일정
-- 홈팀 이름과 원정팀 이름을
-- 구하시오

SELECT stadium_name, game_date, home_team_name, opponent_team_name FROM schedule LEFT JOIN stadium ON schedule.stadium_id = stadium.stadium_id LEFT JOIN team AS home ON schedule.home_team_id = home.team_id LEFT JOIN team AS opponent ON schedule.opponent_team_id = opponent.team_id WHERE home_score - opponent_score >= 3;

-- 034
-- STADIUM 에 등록된 운동장 중에서
-- 홈팀이 없는 경기장까지 전부 나오도록
-- 카운트 값은 19
-- 힌트 : LEFT JOIN 사용해야함

SELECT COUNT(*) FROM stadium LEFT JOIN schedule ON stadium.stadium_id = schedule.stadium_id WHERE schedule.home_team_id IS NULL;

-- 034-1 (페이지네이션) limit 0부터, 5개

SELECT * FROM player LIMIT 5 OFFSET 0;

-- 034-2 (그룹바이: 집계함수 - 딱 5개 min, max, count, sum, avg)
-- 평균키가 인천 유나이티스팀('K04')의 평균키  보다 작은 팀의
-- 팀ID, 팀명, 평균키 추출
-- 인천 유나이티스팀의 평균키 -- 176.59
-- 키와 몸무게가 없는 칸은 0 값으로 처리한 후 평균값에
-- 포함되지 않도록 하세요.

SELECT team_id, team_name, ROUND(AVG(height), 2) AS avg_height FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE height IS NOT NULL GROUP BY team_id, team_name HAVING avg_height < (SELECT AVG(height) FROM player WHERE team_id = 'K04');

-- 035
-- 포지션이 MF 인 선수들의 소속팀명 및  선수명, 백넘버 출력

SELECT team_name, player_name, back_number FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE position = 'MF';

-- 036
-- 가장 키큰 선수 5명 소속팀명 및  선수명, 백넘버 출력,
-- 단 키  값이 없으면 제외

SELECT team_name, player_name, back_number FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE height IS NOT NULL ORDER BY height DESC LIMIT 5;

-- 037
-- 선수 자신이 속한 팀의 평균키보다 작은  선수 정보 출력
-- (select round(avg(height),2) from player)

SELECT player_name, height, team_name FROM player LEFT JOIN team ON player.team_id = team.team_id WHERE height < (SELECT ROUND(AVG(height), 2) FROM player);

-- 038
-- 2012년 5월 한달간 경기가 있는 경기장  조회

SELECT DISTINCT stadium_name FROM schedule LEFT JOIN stadium ON schedule.stadium_id = stadium.stadium_id WHERE game_date BETWEEN '2012-05-01' AND '2012-05-31';

-- 039
-- 2012년 5월 한달간 경기가 있는 경기장  조회

SELECT DISTINCT stadium_name FROM schedule LEFT JOIN stadium ON schedule.stadium_id = stadium.stadium_id WHERE game_date BETWEEN '2012-05-01' AND '2012-05-31';

-- 040
-- 2012년 5월 한달간 경기가 있는 경기장  조회


    