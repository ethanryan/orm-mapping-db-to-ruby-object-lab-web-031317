require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end


  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    array_of_rows = DB[:conn].execute(sql)
    array_of_rows.map do |row|
      self.new_from_db(row)
    end
  end



  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    #DB[:conn].execute(sql,name)
    array_of_rows = DB[:conn].execute(sql,name)
    array_of_rows.map do |row|
      self.new_from_db(row)
    end.first #returns first from array created by map
  end #end method



  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = '9'
    SQL
    #DB[:conn].execute(sql,name)
    array_of_rows = DB[:conn].execute(sql)

    array_of_rows.map do |row|
      row[2] == "9"
    end
  end #end method



  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < '12'
    SQL
    #DB[:conn].execute(sql,name)
    array_of_rows = DB[:conn].execute(sql)
    array_of_rows.map do |row|
      row
    end
  end #end method



  def self.first_x_students_in_grade_10(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = '10'
      LIMIT ?
      --LIMIT x
    SQL
    #DB[:conn].execute(sql,name)
    array_of_rows = DB[:conn].execute(sql,name)
    array_of_rows.map do |row|
      #row[1] == "x"
      row
    end
  end #end method




  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = '10'
      ORDER BY id LIMIT 1
      --ORDER BY id DESC LIMIT 1
    SQL
    #DB[:conn].execute(sql,name)
    array_of_rows = DB[:conn].execute(sql)
    x= array_of_rows.map do |row|
      self.new_from_db(row) #need the student in a hash...
    end.first #...and to then return the object_id? i don't know.
    #puts x
  end #end method



def self.all_students_in_grade_x(grade)
  sql = <<-SQL
  SELECT *
  FROM students
  WHERE grade = ?
  SQL
  #DB[:conn].execute(sql,name)
  array_of_rows = DB[:conn].execute(sql,grade)
  array_of_rows.map do |row|
    row
  end
end #end method


#################
#################
#################

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end



  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end




  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
