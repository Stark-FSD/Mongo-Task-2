--Designing the Zen Class Programme Database


--To design the database for the Zen class programme, we can create the following tables:

--Users Table : This table will store information about the users participating in the Zen class programme. It can include fields like user ID, name, email, and other relevant details.

--Codekata Table : This table will store information about the codekata problems. It can include fields like problem ID, problem statement, difficulty level, and other relevant details.

--Attendance Table : This table will store information about the attendance of users in the Zen class programme. It can include fields like user ID, date, and attendance status.

--Topics Table : This table will store information about the topics taught in the Zen class programme. It can include fields like topic ID, topic name, and other relevant details.

--Tasks Table : This table will store information about the tasks assigned to users in the Zen class programme. It can include fields like task ID, task description, deadline, and other relevant details.

--Company Drives Table : This table will store information about the company drives conducted as part of the Zen class programme. It can include fields like drive ID, drive date, company name, and other relevant details.

--Mentors Table : This table will store information about the mentors in the Zen class programme. It can include fields like mentor ID, mentor name, mentee count, and other relevant details.


--Querying the Database


--1.Find all the topics and tasks taught in the month of October 

db.topics.find({ 
  date: { 
    $gte: new Date('2023-10-01'), 
    $lte: new Date('2023-10-31') 
  } 
});
db.tasks.find({ 
  date: { 
    $gte: new Date('2023-10-01'), 
    $lte: new Date('2023-10-31') 
  } 
});


--2.Find all the company drives that appeared between October 15, 2020, and October 31, 2020

db.company_drives.find({ 
  drive_date: { 
    $gte: new Date('2020-10-15'), 
    $lte: new Date('2020-10-31') 
  } 
});


--3.Find all the company drives and students who appeared for the placement

db.company_drives.aggregate([
  {
    $lookup: {
      from: "attendance",
      localField: "drive_id",
      foreignField: "drive_id",
      as: "attendance"
    }
  },
  {
    $match: {
      "attendance.status": "appeared"
    }
  }
]);


--4.Find the number of problems solved by a user in codekata

db.codekata.aggregate([
  {
    $lookup: {
      from: "attendance",
      localField: "problem_id",
      foreignField: "problem_id",
      as: "attendance"
    }
  },
  {
    $match: {
      "attendance.status": "solved",
      "attendance.user_id": "user_id_here"
    }
  },
  {
    $count: "solved_problems"
  }
]);


--5.Find all the mentors with a mentee count more than 15

db.mentors.find({ 
  mentee_count: { 
    $gt: 15 
  } 
});


--6.Find the number of users who were absent and did not submit the task between October 15, 2020, and October 31, 2020

db.attendance.aggregate([
  {
    $lookup: {
      from: "tasks",
      localField: "task_id",
      foreignField: "task_id",
      as: "task"
    }
  },
  {
    $match: {
      date: {
        $gte: new Date('2020-10-15'),
        $lte: new Date('2020-10-31')
      },
      status: "absent",
      "task.submitted": false
    }
  },
  {
    $count: "users_absent_and_task_not_submitted"
  }
]);
