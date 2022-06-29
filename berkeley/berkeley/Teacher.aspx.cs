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
    public partial class WebForm3 : System.Web.UI.Page
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
            cmd.CommandText = @" SELECT t.Teacher_ID, p.First_Name as ""First Name"", p.Last_Name as ""Last Name"", 
                                TO_CHAR(p.DOB, 'DD Mon, YYYY') as ""Date of Birth"", p.Gender as ""Gender"", p.Email as ""Email"", p.Phone_Number as ""Phone Number"", 
                                TO_CHAR(t.Hire_Date, 'DD Mon, YYYY') as ""Hire_Date"", t.Designation as ""Designation"", t.Salary as ""Salary""
                                FROM teacher t
                                INNER JOIN person p ON t.teacher_id = p.person_id";

            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("Teacher");

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();

            TeacherGridView.DataSource = dt;
            TeacherGridView.DataBind();
        }

        protected void ButtonSubmit_Click(object sender, EventArgs e)
        {
            // insert code
            string first_name = TeaFnameTB.Text.ToString().TrimStart().TrimEnd();
            string last_name = TeaLnameTB.Text.ToString().TrimStart().TrimEnd();
            string dob = DateTime.Parse(TeaDOBTB.Text.ToString()).ToString("dd/MM/yyyy");
            string gender = TeaGenderTB.SelectedValue;
            string email = TeaEmailTB.Text.ToString().TrimStart().TrimEnd();
            string phone_number = TeaPhoneTB.Text.ToString().TrimStart().TrimEnd();
            string hire_date = DateTime.Parse(TeaHireTB.Text.ToString()).ToString("dd/MM/yyyy");
            string designation = TeaDesignTB.Text.ToString().TrimStart().TrimEnd();
            string salary = TeaSalarytTB.Text.ToString().TrimStart().TrimEnd();

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

                cmd = new OracleCommand("Insert into teacher(Teacher_ID, Hire_date, Designation, Salary) Values('" + current_person_id + "', TO_DATE('" + hire_date + "', 'DD/MM/YYYY'),'" +designation + "','"+ salary + "')");
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                ButtonSubmit.Text = "Submit";
                TeacherGridView.EditIndex = -1;
            }
            else if (ButtonSubmit.Text == "Update")
            {
                //get ID for the Update
                string ID = TeacherID.Text.ToString();

                OracleCommand cmd = new OracleCommand("Update Person set First_Name = '" + first_name + "',Last_Name = '" + last_name + "',DOB = TO_DATE('" + dob + "', 'DD/MM/YYYY'), Gender = '" + gender + "',Email = '" + email + "',Phone_Number = '" + phone_number + "' where Person_ID = '" + ID + "'");
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                cmd = new OracleCommand ("Update teacher set Hire_Date = TO_DATE('" + hire_date + "', 'DD/MM/YYYY'), Designation = '" + designation + "',Salary = '" + salary + "' where Teacher_ID = '" + ID + "'");
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                ButtonSubmit.Text = "Submit";
                TeacherGridView.EditIndex = -1;
            }


            // reset all input files
            TeacherID.Text = "";
            TeaFnameTB.Text = "";
            TeaLnameTB.Text = "";
            TeaDOBTB.Text = "";
            TeaGenderTB.SelectedIndex = 0;
            TeaEmailTB.Text = "";
            TeaPhoneTB.Text = "";
            TeaHireTB.Text = "";
            TeaDesignTB.Text = "";
            TeaSalarytTB.Text = "";

            this.BindGrid();
        }


        protected void OnRowCancelingEdit(object sender, EventArgs e)
        {

            this.BindGrid();
            TeacherGridView.EditIndex = -1;
        }

        protected void OnRowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string ID = TeacherGridView.DataKeys[e.RowIndex].Values[0].ToString();
            string constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (OracleConnection con = new OracleConnection(constr))
            {
                using (OracleCommand cmd = new OracleCommand("DELETE FROM Teacher WHERE Teacher_ID = '" + ID + "'"))
                {

                    cmd.Connection = con;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            this.BindGrid();
            TeacherGridView.EditIndex = -1;

        }

        protected void OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex != TeacherGridView.EditIndex)
            {
                (e.Row.Cells[0].Controls[2] as LinkButton).Attributes["onclick"] = "return confirm('Are you sure you want to delete?');";

            }

            //this.BindGrid();
            TeacherGridView.EditIndex = -1;

        }

        protected void OnRowEditing(object sender, GridViewEditEventArgs e)
        {

            // get id for data update
            TeacherID.Text = this.TeacherGridView.Rows[e.NewEditIndex].Cells[1].Text;

            TeaFnameTB.Text = this.TeacherGridView.Rows[e.NewEditIndex].Cells[2].Text.ToString();
            TeaLnameTB.Text = this.TeacherGridView.Rows[e.NewEditIndex].Cells[3].Text.ToString();

            DateTime DOB = DateTime.Parse(this.TeacherGridView.Rows[e.NewEditIndex].Cells[4].Text.ToString());
            TeaDOBTB.Text = DOB.ToString("yyyy-MM-dd");

            TeaGenderTB.SelectedValue = this.TeacherGridView.Rows[e.NewEditIndex].Cells[5].Text.ToString();
            TeaEmailTB.Text = this.TeacherGridView.Rows[e.NewEditIndex].Cells[6].Text.ToString();

            TeaPhoneTB.Text = this.TeacherGridView.Rows[e.NewEditIndex].Cells[7].Text.ToString();

            DateTime HireDate = DateTime.Parse(this.TeacherGridView.Rows[e.NewEditIndex].Cells[8].Text.ToString());
            TeaHireTB.Text = HireDate.ToString("yyyy-MM-dd");

            TeaDesignTB.Text = this.TeacherGridView.Rows[e.NewEditIndex].Cells[9].Text.ToString();
            TeaSalarytTB.Text = this.TeacherGridView.Rows[e.NewEditIndex].Cells[10].Text.ToString();

            ButtonSubmit.Text = "Update";

        }
    }
}