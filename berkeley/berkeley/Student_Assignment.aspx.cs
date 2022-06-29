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
    public partial class WebForm7 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // default load data
            if (!this.IsPostBack)
            {
                this.GetStudent();
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
            cmd.CommandText = @"select s.student_id, p.first_name as ""First Name"", p.last_name as ""Last Name"",
                                a.assignment_name as ""Assignment Name"", mo.module_name as ""Module Name"", 
                                g.Grade as ""Grade"", g.Status as ""Status"",
                                TO_CHAR(m.due_date, 'DD Mon, YYYY') as ""Due Date"",
                                TO_CHAR(m.submitted_date, 'DD Mon, YYYY') as ""Submitted Date""
                                from student s
                                inner join person p on p.person_id = s.student_id
                                inner join marking m on m.student_id = s.student_id
                                inner join Module mo on mo.module_id = m.module_id
                                inner join Assignment_detail a on a.assigment_id = m.assignment_id
                                inner join Assignment_Status g on g.Grade = m.Grade";

            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("Student");

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();

            StudentAssignmenttGridView.DataSource = dt;
            StudentAssignmenttGridView.DataBind();
        }

        private void GetStudent()
        {
            string constr = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            OracleCommand cmd = new OracleCommand();
            OracleConnection con = new OracleConnection(constr);
            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"select s.student_id, concat( p.first_name, concat(' ', concat( p.last_name , concat('  -  ', p.phone_number)))) as ""student_name"" from student s inner join person p on p.person_id = s.student_id";
            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("student");

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();


            DDLStudent.DataSource = dt;
            DDLStudent.DataTextField = "Student_Name";
            DDLStudent.DataValueField = "Student_ID";
            DDLStudent.DataBind();
        }

        
        protected void ButtonView_Click(object sender, EventArgs e)
        {

            this.BindGrid();

        }

        protected void ButtonSubmit_Click(object sender, EventArgs e)
        {

            string student_id = DDLStudent.SelectedValue;

            var constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            OracleCommand cmd = new OracleCommand();
            OracleConnection con = new OracleConnection(constr);

            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"select s.student_id, p.first_name as ""First Name"", p.last_name as ""Last Name"",
                                a.assignment_name as ""Assignment Name"", mo.module_name as ""Module Name"", 
                                g.Grade as ""Grade"", g.Status as ""Status"",
                                TO_CHAR(m.due_date, 'DD Mon, YYYY') as ""Due Date"",
                                TO_CHAR(m.submitted_date, 'DD Mon, YYYY') as ""Submitted Date""
                                from student s
                                inner join person p on p.person_id = s.student_id
                                inner join marking m on m.student_id = s.student_id
                                inner join Module mo on mo.module_id = m.module_id
                                inner join Assignment_detail a on a.assigment_id = m.assignment_id
                                inner join Assignment_Status g on g.Grade = m.Grade
                                where s.student_id = '" + student_id + "'";

            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("Student");

            try
            {
                using (OracleDataReader sdr = cmd.ExecuteReader())
                {
                    dt.Load(sdr);
                }
            }
            catch
            {
                // do nothing
            }

            con.Close();

            StudentAssignmenttGridView.DataSource = dt;
            StudentAssignmenttGridView.DataBind();

        }
    }
}