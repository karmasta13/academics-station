using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace berkeley
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // default load data
            if (!this.IsPostBack)
            {
                this.BindGrid();
            }
        }

        private void BindGrid()
        {

            var constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            OracleCommand cmd = new OracleCommand();
            OracleConnection con = new OracleConnection(constr);

            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @" SELECT s.Student_ID, p.First_Name as ""First Name"", p.Last_Name as ""Last Name"", 
                                TO_CHAR(p.DOB, 'DD Mon, YYYY') as ""Date of Birth"", p.Gender as ""Gender"", p.Email as ""Email"", p.Phone_Number as ""Phone Number"", 
                                TO_CHAR(s.Enrolment_Date, 'DD Mon, YYYY') as ""Enrolment Date""
                                FROM student s 
                                INNER JOIN person p ON s.student_id = p.person_id";

            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("Student");

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();

            StudentGridView.DataSource = dt;
            StudentGridView.DataBind();
        }

        protected void ButtonSubmit_Click(object sender, EventArgs e)
        {
            // insert code
            string first_name = StuFnameTB.Text.ToString().TrimStart().TrimEnd();
            string last_name = StuLnameTB.Text.ToString().TrimStart().TrimEnd();
            string dob = DateTime.Parse(StuDOBTB.Text.ToString()).ToString("dd/MM/yyyy");
            string gender = StuGenderTB.SelectedValue;
            string email = stuEmailTB.Text.ToString().TrimStart().TrimEnd();
            string phone_number = StuPhoneTB.Text.ToString().TrimStart().TrimEnd();
            string enrolment_date = DateTime.Parse(StuEnrollTB.Text.ToString()).ToString("dd/MM/yyyy");

            string constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            OracleConnection con = new OracleConnection(constr);

            if (ButtonSubmit.Text == "Submit")
            {
                
                OracleCommand cmd;
                string current_person_id = "";

                cmd = new OracleCommand("SELECT person_id FROM person WHERE Email = '" + email + "'");
                cmd.Connection = con;
                con.Open();
                using (OracleDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        current_person_id = sdr["person_id"].ToString();
                    }
                }
                con.Close();

                if (current_person_id != "")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Popup", "alert('Email already exists');", true);
                    return;
                }

                cmd = new OracleCommand("SELECT person_id FROM person WHERE Phone_Number = '" + phone_number + "'");
                cmd.Connection = con;
                con.Open();
                using (OracleDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        current_person_id = sdr["person_id"].ToString();
                    }
                }
                con.Close();

                if (current_person_id != "")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Popup", "alert('Phone Number already exists');", true);
                    return;
                }


                cmd = new OracleCommand("Insert into person(First_Name, Last_Name, DOB, Gender, Email, Phone_Number) Values('" + first_name + "','" + last_name + "',TO_DATE('" + dob + "', 'DD/MM/YYYY'),'" + gender + "','" + email + "','" + phone_number + "')");
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                
                cmd = new OracleCommand("SELECT person_id FROM person WHERE Email = '" + email + "'");
                cmd.Connection = con;
                con.Open();
                using (OracleDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        current_person_id = sdr["person_id"].ToString();
                    }
                }
                con.Close();

                cmd = new OracleCommand("Insert into student(Student_ID, enrolment_date) Values('" + current_person_id + "', TO_DATE('" + enrolment_date + "', 'DD/MM/YYYY'))");
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                ButtonSubmit.Text = "Submit";
                StudentGridView.EditIndex = -1;
            }
            else if (ButtonSubmit.Text == "Update")
            {
                //get ID for the Update
                string ID = StudentID.Text.ToString();

                OracleCommand cmd = new OracleCommand("Update Person set First_Name = '" + first_name + "',Last_Name = '" + last_name + "',DOB = TO_DATE('" + dob + "', 'DD/MM/YYYY'), Gender = '" + gender + "',Email = '" + email + "',Phone_Number = '" + phone_number + "' where Person_ID = '" + ID + "'");
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                cmd = new OracleCommand("Update Student set enrolment_date = TO_DATE('" + enrolment_date + "', 'DD/MM/YYYY') where Student_ID = '" + ID + "'");
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                ButtonSubmit.Text = "Submit";
                StudentGridView.EditIndex = -1;
            }


            // reset all input files
            StudentID.Text = "";
            StuFnameTB.Text = "";
            StuLnameTB.Text = "";
            StuDOBTB.Text = "";
            StuGenderTB.SelectedIndex = 0;
            stuEmailTB.Text = "";
            StuPhoneTB.Text = "";
            StuEnrollTB.Text = "";

            this.BindGrid();
        }


        protected void OnRowCancelingEdit(object sender, EventArgs e)
        {

            this.BindGrid();
            StudentGridView.EditIndex = -1;
        }

        protected void OnRowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string ID = StudentGridView.DataKeys[e.RowIndex].Values[0].ToString();
            string constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (OracleConnection con = new OracleConnection(constr))
            {
                using (OracleCommand cmd = new OracleCommand("DELETE FROM Student WHERE Student_ID = '" + ID + "'"))
                {

                    cmd.Connection = con;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            this.BindGrid();
            StudentGridView.EditIndex = -1;

        }

        protected void OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex != StudentGridView.EditIndex)
            {
                (e.Row.Cells[0].Controls[2] as LinkButton).Attributes["onclick"] = "return confirm('Are you sure, you want to delete?');";

            }

            //this.BindGrid();
            StudentGridView.EditIndex = -1;

        }
        protected void OnRowEditing(object sender, GridViewEditEventArgs e)
        {

            // get id for data update
            StudentID.Text = this.StudentGridView.Rows[e.NewEditIndex].Cells[1].Text;

            StuFnameTB.Text = this.StudentGridView.Rows[e.NewEditIndex].Cells[2].Text.ToString();
            StuLnameTB.Text = this.StudentGridView.Rows[e.NewEditIndex].Cells[3].Text.ToString();

            DateTime DOB = DateTime.Parse(this.StudentGridView.Rows[e.NewEditIndex].Cells[4].Text.ToString());
            StuDOBTB.Text = DOB.ToString("yyyy-MM-dd");

            StuGenderTB.SelectedValue = this.StudentGridView.Rows[e.NewEditIndex].Cells[5].Text.ToString();
            stuEmailTB.Text = this.StudentGridView.Rows[e.NewEditIndex].Cells[6].Text.ToString();

            StuPhoneTB.Text = this.StudentGridView.Rows[e.NewEditIndex].Cells[7].Text.ToString();

            DateTime EnrollDate = DateTime.Parse(this.StudentGridView.Rows[e.NewEditIndex].Cells[8].Text.ToString());
            StuEnrollTB.Text = EnrollDate.ToString("yyyy-MM-dd");

            ButtonSubmit.Text = "Update";

        }

    }
}