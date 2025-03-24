<!--image: logo-->
  ![App logo](./assets/logo/logo_org.svg)
# 🚀 Joblagbe.com  

A **skill-based job-finding platform** where applicants must pass an **MCQ exam** based on the job they want to apply for.  
Each applicant gets a **maximum of 2 chances** to pass the MCQ round:  
- **First attempt**: Available for all applicants.  
- **Second attempt**: Available only if the applicant completes the suggested course for the test.  

The **courses** are managed by the **admins** of the **joblagbe.com** site.  

## 📊 Dashboards:  
- **Applicant**  
- **Recruiter**  
- **Admin**  

## ✨ Features:  

### 🔹 Role-based Authentication  

### 🔹 Recruiter:  
- View & Explore all available jobs (posted by themselves or others).  
- View & Explore available courses.  
- **Add & Manage Job Posts** (Recruiters must complete their profile before posting a job. If incomplete, they will receive a warning).  
- View & Manage applications received for job posts.  
- Manage their profile.  

### 🔹 Applicant: (**Coming Soon**)  

### 🔹 Admin: (**Coming Soon**)  

## Project Structure
```
joblagbe
├──assets
├──lib
│   ├──app
│   │   ├──core
│   │   │   ├──constants
│   │   │   ├──middleware
│   │   │   ├──routes
│   │   │   ├──theming
│   │   │   │   ├──colors
│   │   │   │   └──theme
│   │   │   ├──utils
│   │   │   └──widgets
│   │   ├──modules
│   │   │   ├──404
│   │   │   │   └──views
│   │   │   ├──auth
│   │   │   │   ├──controllers
│   │   │   │   ├──models
│   │   │   │   ├──services
│   │   │   │   ├──state
│   │   │   │   └──views
│   │   │   │   │   ├──login
│   │   │   │   │   │   ├──parts
│   │   │   │   │   └──register
│   │   │   │   │   │   └──views
│   │   │   │   │   │   │   └──pages
│   │   │   │   │   │   │   │   ├──parts
│   │   │   ├──dashboard
│   │   │   │   ├──applicant
│   │   │   │   │   ├──home
│   │   │   │   │   │   └──pages
│   │   │   │   │   ├──jobs
│   │   │   │   │   │   └──pages
│   │   │   │   │   └──wrapper
│   │   │   │   │   │   ├──controller
│   │   │   │   │   │   └──pages
│   │   │   │   └──recruiter
│   │   │   │   │   ├──add-job
│   │   │   │   │   │   ├──controllers
│   │   │   │   │   │   ├──models
│   │   │   │   │   │   ├──pages
│   │   │   │   │   │   │   ├──parts
│   │   │   │   │   │   └──services
│   │   │   │   │   ├──applications
│   │   │   │   │   │   └──pages
│   │   │   │   │   ├──home
│   │   │   │   │   │   └──pages
│   │   │   │   │   ├──jobs
│   │   │   │   │   │   └──pages
│   │   │   │   │   ├──profile
│   │   │   │   │   │   ├──controllers
│   │   │   │   │   │   ├──models
│   │   │   │   │   │   ├──pages
│   │   │   │   │   │   │   ├──parts
│   │   │   │   │   │   └──services
│   │   │   │   │   └──wrapper
│   │   │   │   │   │   ├──controllers
│   │   │   │   │   │   └──pages
│   │   │   ├──forgot_password
│   │   │   │   ├──controller
│   │   │   │   ├──services
│   │   │   │   └──views
│   │   │   │   │   └──pages
│   │   └──_app.dart
│   ├──firebase_options.dart
│   └──main.dart
├──test
│   └──widget_test.dart
├──analysis_options.yaml
├──cors.json
├──pubspec.lock
├──pubspec.yaml
├──README.md
├──.gitignore
└──.metadata
```

## 🛠️ Technologies Used  
| Component        | Technology |
|-----------------|------------|
| **Frontend**    | Flutter    |
| **Backend**     | Firebase   |
| **State Management** | GetX  |
| **Routing**     | Go-Router  |
| **Local Storage** | Get-Storage |

---

## 🧑‍💻 Author  
**Kaium Al Limon**  

---

## 📝 License  
This project is licensed under the **MIT License**.  