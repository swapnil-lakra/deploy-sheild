Date - 10/06/2026
1. Mujhe poore acche se detail me samajhna hoga uss business problem ko.

2. Business problem ko acche se samajhne ke liye mujhe aise keywords ke baare me research karna padega jo mujhe bata nahi hai ?

3. Iss business problem me `git pull` ke baare me address kiya gaya hai toh mujhe samjhna hoga ki ye `git pull` kya hai aur isse kyu use kiya jaata hai

4. `git pull` kya hota hai mujhe poori tarah se samajh aa gaya hai. Research.md me point no. 1 me document kiya gaya hai.

5. Agar hum code ko server me deploy karte hai only `git pull` use karke without implemented ci/cd pipeline toh wo kyu break ho jaata hai?

6. mujhe ab poora samajh aa gaya kyu kewal `git pull` without implemented ci/cd pipeline break hota hai. Research.md me point no. 2 me document kiya gaya hai.

7. Reason kya hai ki developer code ko wrong branch pe push kar dete hai? aur .env file bhool jaate hai? 

8. mujhe poora samajh aa gaya kyu developer code ko wrong branch pe push kar dete hai aur .env file bool jaate hai. Research.md me point no. 3 me document kiya gaya hai.

9. ye node process kya hota hai ?

10. mujhe samajh me aa gaya ye node process hota kya hai. Research.md me point no. 4 me document kiya gaya hai.

11. kabhi node process hang hone ka reason kya hai ? aur isko kaise avoid kar sakte hai

12. mujhe samajh me aa gaya kyu node process hang ho jaata hai aur usko avoid kaise karna hai. Research.md me point no. 5 me document kiya gaya hai.
 
13. Ye rollback strategy kya hota hai ? Aur isko use karne ke benefits kya hai ? agar rollback strategy use nahi kiya toh kya hoga ?

14. mujhe rollback strategy ke baare me samajh aa gaya. Research.md me point no. 6 me document kiya gaya hai.

15. Maine jab rollback strategy ke baare me research kiye toh mujhe rollback strategy ke types pata chala aur usme blue-green deployment bhi tha jisse mai thoda bahut fimilier hun.

16. Ye Blue-Green Deployment kya hota hai ? Isko use karne ke benefits kya hai ? Agar use nahi kiya toh kya hoga ?

17. Mujhe Blue-Green Deployment ke baare me samajh aa gaya.  Research.md me point no. 7 me document kiya gaya hai.

18. Iss business problem ko solve karne ke liye mujhe sabse phela step kya lena chahiye ?

19. Ab Mujhe Samajh Aa gaya ki mujhe sabse phele solution ka architecture create karna hai

20. Toh mujhe architecture diagram ke samajh aa raha hai ki ek central repository hoga jisme developer code push karega.

Date - 11/06/2026

21. Toh mujhe sabse phele decide karna padega ki ye central code repository konsa hoga.

22. maine decide karke ARD.md me point no. 1 me document kar liya hai.

23. Ab mujhe decide karna hai ki konsa ci/cd pipeline tools use karna hai ?

24. maine decide karke ARD.md me point no. 2 me document kar liya hai.

25. Ab mujhe containerization ke baare me jaana padega kyuki application ko remote ec2 server pe run karna hai aur 'it's works on my machine' wali problem na ho.

26. Ab ye containers kya hote hai aur inka kya kaam aur hum containers use na kare toh kya hoga ?

27. Mujhe samajh me aa gya ki ye containers kya hote hai aur maine isko Research.md me point no. 8 me document kar liya hai

28. Ab mujhe decision making karna hai containerization tools ko choose karne ke liye.

29. Mai containerization tool ko choose kar liya hai aur usko ARD.md me point no. 3 me document kar diya hai 

30. Ab mujhe samajhna padega ki Dockerfile kaise likhte hai aur fir Dockerfile se image kaise banate hai fir uss image ko remote docker image repository me push kaise karte hai aur fir uss docker image se container kaise banate hai fir run kaise karte hai aur saath hi docker compose kya hai aur kyu use hota hai

31. Ab mujhe sab samajh me aa gaya Dockerfile banane se lekar image build karne tak, fir image se lekar usko remote registry me push karne tak, fir remote registry se pull kar ke deploy karke container ko run karne tak , Aur usko mai Research.md ke point no. 9 me document kiya hai.

32. ab mujhe samajhna padega ki mai kaise blue-green deployment strategy ko apply kar sakta hun

33. leking usse phele mujhe ye jaan na padega ki mai application code ko github me push karunga, toh github action trigger hoga, toh uss code ka image build hoke container registory me push hoga, fir wo uss build image ko container registory se aur code ko github se kaise pull karke remote server me kaise deploy karunga

34. ab isko samajhne ke liye mujhe phele central image registory ko choose karne liye decison making karna padega

35. maine ECR choose kiya hai aur ARD.md me point no. 4 me document kiya hai

36. ab deployment pe aate hai, mujhe jaana padega ki kaise mai AWS ECR se docker image ko pull karke ec2 me deploy kar sakta hun

37. ab mujhe code ko github me push karne se lekar deployment karne tak ka complete picture samajh aa gaya hai aur mai usko Research.md me point no. 10 me document kiya hu

38. ab main jo bhi research kiya hun uss basis par implement karunga

Date - 12/06/2022

39. ab mujhe ek application banana padega just for demo usme nextjs se frontend banega aur backend fastapi se aur mysql database bhi connect hoga 

40. aur mujhe uss application me database se jitna bhi data hai usko frontend me display karna hai  

41. fir mai unke liye Dockerfile bana ke unka image create karunga 

42. mai Dockerfile banane start karne ke phele mujhe ek confusion hai ki d2c-fashion-app ek fullstack application hai jisme frontend aur backend dono hai, toh fir mujhe dono ek liye seperate Dockerfile banana padega ya fir ek hi Dockerfile me dono rahega ?

43. mujhe samajh aa gaya unn dono ke liye seperate Dockerfile banana padega aur root folder me kewal docker-compose.yaml file rahega aur mai isko Research.md me point no. 11 me document kiya hai 

44. chalo ab d2c fashion app ready ho gayi hai

45. Ab mai Dockerfile likh sakta hun frontend aur backend ke liye aur saath hi .dockerignore file bhi add karna padega.

46. Application ke frontend aur backend ke liye maine Dockerfile aur .gitignore likh liya hai aur mai isko implementations.md me point no. 1 me document kiya hu

Date - 14/06/2026

47. Application ke frontend and backend ke liye main Docker images create kiya hai aur usko implementations.md me point no. 1 and 2 me document kiya hu 

48. Kyuki d2c fashion application me frontend + backend + database hai toh mujhe inke images ko docker-compose se manage karna padega.

49. Lekin docker-compose se phele mujhe samajhna padega ki ye hota kya aur iska use kya hai aur hum isko use na kare toh fir kya hoga ?

50. Ab mujhe acche se pata chal gaya, docker-composer kyu use hota hai aur use nahi kiya jaaye toh kya hoga aur mai isko research karke Research.md me point no. 12 me document kiya hua hai.

51. Mai docker-compose.yaml file create kar liya hai ab mujhe `docker compose up -d` command use karke multiple containers ko orchestration implement karna hai

Date - 15/06/2026

52. maine `docker compose up -d` command run karke multiple containers ko orchestration implement karke Implementation.md me point no. 4 me document kiya hu

53. mera d2c fashion application consists of frontend(nextjs) + backend(fastapi) + database(mysql), toh mujhe nahi lagta ki inke images ec2 me container ban ke run ho paayenge and most likely ec2 OoM(Out of Memory) ho jaayega kyuki mai aws ke free tier me hu aur mai ec2 type t3.micro use kar raha hun jisme only 1gb memory hoti hai

54. Fir bhi mai ek baar try karke dekhunga bhale hi fail kyu na ho jaaye

55. lekin usse phele mujhe frontend(nextjs) + backend(fastapi) ke docker images ko ek central image registry me push karna padega 

56. Maine phele decide kiya tha ECR me docker images ko push karunga but uski free tier ki limit 500mb ki hai aur application ke docker images ki size 500mb ko bhi exceed kar rahi hai toh mujhe inhe kisi doosre image registory me push karna padega jiski free limit 500mb ko exceed karti ho.

57. Maine GHCR(GitHub Container Registry) ko choose kiya kyuki ye public images ke liye 100% free unlimited storage provide karta hai aur private images ke liye only 500mb , toh ye mere liye kaafi hai

58. Maine GHCR(GitHub Container Registry) ko choose kar liya hai aur iske trade-offs aur consequences ko maine ARD.md me point no. 5 me document kiya hai

59. Ab mujhe sabse phele research karna padega ki docker images ko kaise GHCR(GitHub Container Registry) me push karte hai 

60. maine GHCR(GitHub Container Registry) me kaise push karte hai uska research karke Research.md me point no. 12 me document kiya hun.

61. mai apna PAT(Personal Access Token) successfully generate kar liya hai

62. ab mai frontend(nextjs) aur backend(fastapi) ke docker images ko HCR(GitHub Container Registry) me push karne jaa raha hun

63. frontend(nextjs) aur backend(fastapi) ke docker images ko GHCR(GitHub Container Registry) me successfully push ho gaya hai aur usko Implementation.md me point no. 5 me document kiya gaya hai

64. ab mujhe pata karna padega ki mai docker-compose.yaml me wo images ka name likhu jo GHCR(itHub Container Registry) me push kiya hu toh kya wo uss image ko automatically pull karke container run karega ya nahi.

65. agar docker images public image registry me hai toh bina kisi login ke automatically pull karlega lekin agar wo docker image private image registry me hai toh fir remote server me login karke PAT(Personal Access Token) dena hoga fir wo automatically pull kar lega

66. mai GHCR(GitHub Container Registry) ke images ki visibiliy ko private se change karke public kar diya hun

67. ab mai apne ec2 me d2c fashion application ka code ko github se clone karke usme `docker-compose.yaml` file se `docker compose up -d` command run karunga

68. mai d2c fashion application ke docker image se container run kiya aur wo successfully run ho gaya ✅

69. ab container toh run ho rahe hai but mai unko access nahi kar paa raha tha because mai aws cloud me vpc me security-group me inbound rule me unke ports (3000 and 8000) ko access from anywhere rule add nahi kiya tha

70. maine rule add kar liya hai, ab acces karne ka try karta hun.

71. mai successfully d2c fashion application ke frontend aur backend ko access kar paa raha hun

72. maine socha tha ec2 par d2c fashion application ke containers(frontend+backend+database) run nahi ho paayegne aur run hua toh fir wo OoM(Out of Memeory) ho jaayega but aisa nahi hua to fir mai aage continue kar sakta hun

73. ab samay aa gaya hai most awaited GitHub Actions ka, jisse mai CI/CD pipeline banaounga

74. Usse phele mujhe thoda GitHub Actions ke baare me padhna padega 

Date - 17/06/2026

75. Mai GitHub Actions ke baare me samajh gaya hun ab mai isse CI/CD pipeline create karunga

76. Ab mujhe ye samajhna padega ki jab mai GitHub Actions ka use karke CI/CD pipeline create karunga toh jab wo build hoga toh konse se machine use hoga build hone me, suppose application ka build karna hai docker image toh fir konsa machine use hoga mera remote server jisme application deploy hone wala hai ya fir github ka khud ka machine ?

77. Mujhe samajh aa gaya jab application ko build karne ka time aata hai toh GitHub Action apne GitHub-Hosted Runner me build karta hai aur mai isko Research.md me point no. 14 me document kiya hu

78. mai GitHub Actions ke CI/CD workflow ke liye folders aur files bana liya hai aur mai usko implementation.md me point no. 6 me document kiya hai

79. Mai GitHub Actions se poora CI/CD Workflow bana liya hai ".github/workflows/d2c-fashion-cd-cd.yaml" me

80. Ab GitHub Actions me secrets ka kaise use karna hai ye jaan na padega.

81. Maine Github me secrets ko add kar liya hua hai apne repository ke liye

82. Maine Abhi GitHub Actions me CI/CD Workflow bhi create kar liya hua hai aur secrets bhi add kar liya hun ab mai next step kya le sakta hun

Date - 18/06/2026

83. Mai ek mistake kar diya hu wo mujhe abhi pata chal raha hai, mai frontend + backend ke liye ek hi ci/cd workflow create kiya, dono ke liye seperate ci/cd workflow hona chahiye 

84. Abhi mai dono ke liye seperate create kar raha hun

85. Mai Frontend aur backend dono ke liye successfully seperate ci/cd workflow ke liye folder aur yaml file create kar liya hai aur usko Implementation.md me point no. 6 me document kiya hai

86. Mai phele socha tha ki cloud native tool aws CodeDeploy se blue-green deployment banaounga but unfortunately mai CodeDeploy ko use nahi kar sakta kyuki mera aws account fully registered nahi hai aisa show kar raha hai aur jab tak fully registerd nahi hoga tab rak mai CodeDeploy use nahi kar sakta 

87. Ishiliye mujhe alternate path find karna padega blue-green deployment ko implement karne ke liye

Date - 19/06/2026

88. Phele mujhe ye pata lagana padega ki mai kaise blue-green deployment aur saath hi automatic rollback agar /health endpoint fail ho toh 

89. Mai bina CodeDeploy ke blue-green deployment achieve kar sakta hun wo bhi bash scripting ka use karke

90. Mujhe pata chala hai ki mujhe Nginx jo ek load balancer hai uska use karna padega.

91. Ab mujhe ye pata lagana padega ki Nginx ka kya role hai blue-green deployment achieve karne me.

92. Nginx ka kya role hai blue-green deployment me isko maine Research.md me point no. 15 me document kiya hai

93. Mujhe research karke pata chala hai ki mere application ke frontend aur backend dono me /health checkpoint hona chahiye 

94. But mere application me nahi hai toh mujhe sabse phele /health endpoint ko implement kar chahiye 

95. Jab me /health endpoint ko implement karunga toh meri ci/cd pipeline ki bhi testing ho jaayegi , toh mai dekh paounga ki ye ci/cd pipeline jo mai implement kiya hu wo sahi se kaam kar bhi raha hai ya fir nahi 

96. Maine frontend aur backend me /health endpoint ko implement kar diya hai aur usko github me push kar kar diya hai

97. Ab CI/CD pipeline latest git repositry ke hissab se ec2 me deploy karega 

98. CI/CD pipeline break ho gayi kyuki frontend aur backend ka docker image build nahi ho paya aur mai isko 4-RCA-&-Incident-Journal.md me point no. 8 me document kiya hai

99. Ab mujhe ye jaan na padega ki same name se 2 baar docker image ko GHCR(GitHub Container Registry) me push kare toh kya hoga ?

100. Mujhe samajh aa gaya hai ki jab ham docker image ko same name se 1 baar se jyada GHCR(GitHub Container Registry) me push karenge toh kya hoga aur mai usko Research.md me point no. 16. me document kiya hai

101. mujhe ab ye pata karna padega ki jab mai docker image build karke usko GHCR(GitHub Container Registry) me push karunga toh kya wo by default public image registry me push hogi ya nahi kyuki GHCR(GitHub Container Registry) ki private image registry me only 500mb tak image ko store karne ke liye free hai?

102. mujhe pata chal gaya jab mai ek baar private images ki visibiliy private kar deta hun toh wo next time push hogi toh wo public image registry me push hogi

103. phele mera jo frontend aur backend docker image build fail hua tha ab mai uske jobs ko re-run karunga

104. uss phele mujhe github context ke baare me jaan na padega khas kar ki ye dono - github.repository,github.event.respository.name 

105. mujhe  github context (github.repository,github.event.respository.name) ke baare me samajh aa gaya hai aur mai isko Research.md me point no. 17 me document kiya hun.

106. Abhi fir se backend ki ci/cd pipeline break hui hai docker image ko push karte waqt, mujhe pata lagana padega ki kyu break hui ?

107. Mujhe pata chal gaya error ishiliye occur hua kyuki mai packages create karne ki permissions (Write access) nahi diya tha aur mai isko RCA-&-Incident-Journal.md me point no. 9 me document kiya hai

108. Ab backend ka ci/cd pipeline bilkul mast chal raha hai aur ec2 me deploy bhi ho raha hai 

109. ab paari hai frontend ki ab mujhe iski ci/cd pipeline check karna padega taaki pata chale ki ye ec2 me deploy ho raha hai ya fir nahi

110. frontend ka bhi ci/cd pipeline proper work kar raha hai

Date - 20/06/2026

111. frontend aur backend me maine /health endpoint add kiya tha jo bahut acche se system ki health status bata rahi hai

112. Ab mujhe ye jaan na padega ki docker containerized application jiska ci/cd pipeline se docker image build, GHCR(GitHub Image Registry) me push aur ec2 deployment me container run ho raha hai usme mai kaise blue-green deployment implement kar sakta hun.  

113. Mai samajh gaya hun mujhe blue-green deployment implement karne ke liye ek core component ke jaroorat padegi aur uska naam hai Load Balancer.

114. Ab mujhe Load Balancer choose karne ke liye decision making karna padega.

115. Maine Nginx Load Balancer ko choose karne ka decision liya hua hai aur mai isko ARD.md me point no. 6. me document kiya hu.

116. Ab mujhe Nginx ke baare me jaan na padega ki nginx blue-green deployment me behind the scene kaise kaam karta hai.

117. Mujhe sab samajh gaya ki nginx, blue-green deployment me kaam kaise karta hai aur mai usko Research.md me point no. 18 me document kiya hai 

118. Ab mujhe blue-green deployment behind the scene kaise kaam karta hai ye jaan ne liye liye phele mai manual blue-green deployment kar raha hun aur manual rollback karunga aur intentionally green environment application ko down karunga fir blue environment me switch karunga manually

119. Sabse phele mujhe 2 environment banana padega blue aur green

120. Mujhe blue aur green environment ke liye 2 seperate port ready karna padega 

121. Blue environment ports - frontend (3000) aur backend (8000), Green environment ports - fontend (3001) aur backend (8001)

122. Mera blue environment phele se hi ready hai ab kewal green environment create karna hai 

123. Blue environment me frontend aur backend + mysql ka port docker-compose.yaml se define hua tha toh mujhe green environment me frontend aur backend + mysql port koi kaise define karna hai ye jaan na padega.

124. Oh ab mujhe poori picture clear ho gayi hai, jaisa ki maine blue environment me frontend aur bakckend + mysql ke port ko docker-compose.yaml se define ki hai waise hi mujhe green environment ke liye bhi karna padega 

125. ab mujhe application ke folder ke andar me 2 folder create karna hai blue aur green jisme blue wale folder me blue envionment ke hissab se docker-compose.yaml me application ki port define hogi  aur green file me green enviroment ke hissab se docker-compose.yaml me application ki port define hogi

126. Ab mujhe ye jaan na padega ki blue aur green dono environment ke liye shared database use karna chahiye ya fir seperate database use karna chahiye

127. ab mujhe samajh me aa gaya ki production me dono green-blue environment me seperate database use karna recommended hai aur mai isko Research.md me point no. 19. me document kiya hu

128. mai d2c fashion application ke root directory me blue aur green environment ke liye folder create kar liya hai aur docker-compose file bhi aur mai usko implementation.md me point no. 7 me document kiya hai

129. ab mujhe green wale docker-compose.yaml file me applications ke ports change karna hai 

Date - 21/06/2026

130. mai successfully blue green environment me application ko manually run kar liya hun

131. but ek new problem arise ho gayi hai , kyu ek saath application ko 2 alag port me run ho raha hai toh fir memory bahut jyadaza consume ho raha hai almost 95% toh mujhe frontend jo nextjs me hai usko remove karna padega aur reactjs ka use karke frontend banana padega 

132. maine reactjs me d2c fashion app ka frontend develop kar liya hai aur mai usko mai Implementation.md me point no. 8 me document kiya hun

133. frontend app bahut acche se develop ho gaya hai aur poore products ki listing aa rahi hai aur designing bhi acchi ho gayi hai 

134. frontend me error occur ho gaya hai, developement environment me backend server se easily connect ho raha hai but docker build ke baad frontend container ka container run kar raha hun toh wo backend server se connect nahi ho raha hai.

135. error occur hone ka reason find out karne me mujhe 3 hours lag gaye aur reason ye hai ki react ki application production build hone ke baad vite ke inbuild custom server par run nahi hoti ishiliye usko external web server ki jaroorat padti hai jaise nginx

136. ab mujhe ye jaan na padega ki kyu react application production build ke baad vite ke inbuild custom web server me run kyu nahi hoti hai ?

137. ab mujhe samajh aa gaya ki react production build application ko kyu external web server ki need padti hai aur mai isko Research.md me point no. 20 me document kiya hu

Date - 23/06/2026

138. ab aate hai uss error pe jo react app ke production build ke baad external web server jaise nginx ke wajah se occur hui thi kyuki nginx ke server ki routing misconfiguration ke karan hui thi aur isko mai 4-RCA-&-Incident-Journal.md me point no. 10 me mention kiya hua hai

Date - 24/06/2026

139. mujhe blue green deployment ke liye ci/cd workflow me bash scripting likhna padega aur ci/cd pipeline jo phele bana tha usko blue-green deployment ke hissab se mujhe reconstruct karna padega

Date - 25/06/2026

140. maine frontend aur backend ke ci/cd worflow me build section ko reconstruct kar liya hai ab mujhe un dono ka deployment section ko reconstruct karna padega jo blue-green deployment hoga.

141. ab mujbhe 2 bash file create karna padega, frontend aur backend ke liye aur usme blue-green deployment ke scripting karna padega.

142. lekin usse phele mujhe blue aur green environment ko run karna padega aur dekhna padega, blue aur green environment me application acche se run ho rha hai ya nahi aur mai isko Implementation.md me point no. 9 me document kiya hu

143. ab mai sabse phele blue environment ko run kar rha hun toh error occur ho rha hai aur wo error occur hone ka reason hai environment variable detect nahi ho paana aur mai uss error ke baare me 4-RCA-&-Incident-Journal.md me point no. 11 me document kiya hu

Date - 26/06/2026

144. ab sab sahi se run ho raha hai lekin mariadb me initialization sql file run nahi ho paayi jisse ki database me tables create nahi hua aur usme data bhi add nahi ho paaya ye bhi environment is not detected wala error jisko mai 4-RCA-&-Incident-Journal.md me point no. 11 me document kiya hu

145. ab mujhe frontend me nginx server me error aa raha hai aur uss error aane ka reason hai nginx configuration me simicolon ka missing hona aur mai uss error ko resolve karke mai 4-RCA-&-Incident-Journal.md me point no. 12 me document kiya hu

146. mai frotend image ko build kar raha hun toh mujhe error occur ho raha hai aur uss error occur hone ka main reason hai jab docker file build ho rha hai toh use bash file ko executable banane ke liye root user ke permission na milna aur mai isko resolve karke 4-RCA-&-Incident-Journal.md me point no. 13 me document kiya hu

147. Abhi mai green environment me d2c fashion app ko run kar raha hun toh backend ka container `unhealthy` ho raha hai due to healthchek test fail hua aur mai isko resolve karke 4-RCA-&-Incident-Journal.md me point no. 14 me document kiya hu 

148. green environment ke backend ka healthcheck test ishiliye fail ho raha tha kyuki wo `curl` ka use kar raha tha jo container me installed hi nahi thi aur healtcheck test fail hone ke par bawjood backend bahut smooth chal raha tha toh mai soch raha hu ki waise toh mai frontend ka healthcheck test karne ke liye mai `wget` ka use kiya hun but wo bhi usme installed nahi hogi 
  
Date - 30/06/2026

149. frontend ka healthcheck test fail ho raha tha kyuki `wget` tool installed nahi tha toh mai isko install karne ka command add kar diya hu toh jab frontend ka image build hoga toh wo `wget` tool ko install kar dega au mai isko Implementation.md me point no. 10 me document kiya hua hai

150. kyuki mai frontend ke liya `nginxinc/nginx-unprivileged:alpine-slim` image use kar raha hun jisme `apline` linux distribution use hua hai aur wo baaki normal distribution se bahut agal hai jiski wajah se mujhe bahut saare error ko face karna pada hai

151. aur mujhe `nginxinc/nginx-unprivileged:alpine-slim` ko choose karne ka decision making kiya hai kyuki ye nginx image bahut jyada secure hai

152. nginx ke docker image `nginxinc/nginx-unprivileged:alpine-slim` jo error occur hue hai mai usko 4-RCA-&-Incident-Journal.md me point no. 15, 16 me document kiya hu

153. ab mai green environment ne docker compose use kar ke container ko run kar raha hun toh fir se ek error aa gaya hai aur wo error nginx me `invalid directive` ka use kiya hu ishliye occur hua hai aur mai usko 4-RCA-&-Incident-Journal.md me point no. 17 me document kiya hu

154. ab jo error aaya tha usko fix kar ke baad container run kar raha hun toh fir ek aur error aa raha hai aur wo error ishliy aa raha hai kyuki mai backend host ka name invalid hai meri mistake ki wajah se aur bahut hi silly mistake hua hai mere se aur mai isko 4-RCA-&-Incident-Journal.md me point no. 18 me docuement kiya hua hu

155. jab mai silly mistakes wale error ko solve kar liya toh fir se ek aur error occur hua hai aur wo error ishiliye occur hua hai kyuki mujhe host machine aur container ke port me difference clear nahi tha aur mai container port ki jagah host machine ka port no. use kar liya tha aur mai isko 4-RCA-&-Incident-Journal.md me point no. 19 me document kiya hua hu

156. finally several errors ke baad blue aur green environment par d2c-fashion-app successfully run ho rahe hai toh mai ab blue-green deployment ki taraf aage badh sakta hun

Date - 01/07/2026

157. ab mujhe ye jaan na padega ki mai blue aur green environment ke liye application me application ko run toh kar paa raha hu lekin mujhe uske automatic rollback karne se phele mai kaise manually rollback kar sakta hun blue environment me

158. mujhe samajh aa gaya mai ye nginx ke help se kar sakta hun upstream ka use karke lekin ab mujhe ye samajhna padega ki ye upsteam hota kya hai, kyu use hota hai aur kya blue-green deployment me isse use karna jarrori hai?, agar use nahi kiya jaaye toh kya hoga.

159. mujhe samajh me aa gaya nginx me upsteam hota kya hai, kyu use hota hai aur kya blue-green deployment me isse use karna jarrori hai?, agar use nahi kiya jaaye toh kya hoga aur isko mai Research.md me point no. 21 me document kiya hua hun

Date - 02/07/2026

200. Ab mai ci/cd workflow me backend ka docker image build karne jaa raha hun toh mujhe ye pata karna padega ki mai blue aur green ke liye docker image kaise banane ke liye konsa tagging karna sabse best rahega

201. mujhe samajh aagay hai taggin kaise karni hai build ke baad usme `:latest` aur `:${{ github.sha }}` ko add karna jisse kya hoga ki jab fir se naya build hoga toh `:latest` uss naye wale build ke saath attach ho jaayega 

202. ab mujhe backend ke ci/cd workflow me step create karna padega jo check kare ki frontend ka image exists karta hai ya nahi aur agar nahi exist karega toh frontend ka image bhi build hoga aur exist karega toh forntend ka image build nahi hoga

203. frontend exist karta hai ya nahi iske liye steps create kar liya hai ab latest build image ke liye `:latest` tag ko add kar liya aur usse one step peeche  build image ko `:previous` ka taga add kar diya hu

204. aur yehi same mai frontend ke ci/cd pipeline ke worflow me bhi add kar diya hu

205. ab mai baari hai bash scripting kar ke blue-green deployment karne ki 

206. sabse phele mujhe ye check karne ka bash script likhna padega ki `docker-compose.blue.yaml`,`docker-compose.green.yaml` and `complete-deployment.sh` file aur uska folder exist karta hai ya nahi

207. agar wo files exist nahi karte toh wget ka use karke file downlaod ka script add kar diya hu aur exist karte hai toh wget se file download karke check hoga jo already download file agar ko difference najar aayega to new download ko keep karega aur jo already downlaoded file tha wo delete ho jaayega

208. ab mujhe ec2 me docker install hai ya nahi uske liye script likh liya hun jo check karta hai ki docker nahi hai toh install kar deta hai 

209. ab docker ko install hone ke baad ye check karne ka script likha hun jo docker is service start aur enable hai ya nahi aur agar nahi hai toh automatically start aur enable ka command se karne ka script add kar diya hu

210. ab ye check karna hai ki konsa envionment run ho raha hai, blue ya fir green ya wo dono aur iska script likha hu

Date - 03/07/2026

211. mai deployment script me jab koi bhi environment running nahi hai tab blue environment ko start karne aur jab blue environment running hai toh green environment ko start karna likh diya hun

212. ab mai ek major decision le raha hu aur wo ye hai mere pass ci/cd pipeline ke liye 2 file thi ek backend aur ek frontend ke liye aur usme most of the content similar the toh mai usko ek single file me rewrite karunga aur wahi same mai docker compose ke liye bhi karunga ushme bhi 2 files hai ek blue aur green environment ke liye lekin usme most of the content similar hai toh mai usko ek file me rewrite karunga

Date - 05/07/2026
213. maine success fully jaha 2 ci/cd worflow aur docker compose files ke liye 1 single file me merge kar diya hai jisse 1 chiz 2 baar repeat nahi ho rahi hai

214. ab mujhe nginx.conf me nginx ki configuration karni hai jisse ki blue aur green dono environment ke manage kar sake, agar green fail ho toh blue me rollback ho jaaye 

215. maine nginx.conf me dono environment ke upstream add kar diya hai

216. ab mujhe ye jaana padega ki green environment ha /health ko kaise monitor karna jisse se healthcheck fail ho toh blue me automatically rollback ho jaaye aur fir green ka healcheck dobara pass ho toh wapas green me shift ho jaaye with zero-downtime

217. mujhe samajh me aa gaya, /health koi monitor karne ke liye systemd (daemon process ko background me run hota hai) create karna padega

Date - 06/07/2026
218. blue and green environment ka health check karne ke liya mai service aur bash script ready kar li hai 

219. maine complete-deployment.sh me nginx ko install karna fir configure karna fir health-monitor.service ko background me run karne aur fir check karna ki konsa environmnent active hai toh uss hissab se new environment ko start karne ka script ko likh diya hun ko

220. jo maine health-monitor.service jo background me chalega aur health-monitor.sh file me agar green environment down hua toh blue me automatically rollback hona aur fir se green environment up hua toh rollforward hona bhi usme likha hun

221. ab complete-deployment.sh,docker-compose.yaml, pipeline.yaml aur health-monitor.server,health-monitor.sh ko execute karke check karna ki wo sahi se work kar raha hai nahi agar nahi kiya to find out karunga kyu run nahi ho raha hai aur mai usko rca journal me document karunga 

Date - 07/07/2026

222. maine jitne bhi file me changes kiye hue the usko github me push kar diya hun 

223. ab mai blue green deployment with ci/cd pipeline ko test karne ke liye ki sahi se kaam kar bhi raha hai ya nahi backend me halka sa changes karke usko github me push karunga 

Date - 08/07/2026

224. 








 







