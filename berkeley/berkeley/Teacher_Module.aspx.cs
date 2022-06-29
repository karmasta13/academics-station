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
    public partial class WebForm5 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // default load data
            if (!this.IsPostBack)
            {
                this.GetTeacher();
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
            cmd.CommandText = @"select t.teacher_id, p.first_name as ""First Name"", p.last_name as ""Last Name"", p.phone_number as ""Phone Number"",
                                m.module_id as ""Module ID"", m.module_name as ""Module Name""
                                from teacher t
                                inner join person p on p.person_id = t.teacher_id
                                inner join module_teacher mt on mt.teacher_id = t.teacher_id
                                inner join module m on m.module_id = mt.module_id";

            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("Teacher");

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();

            TeacherModuleGridView.DataSource = dt;
            TeacherModuleGridView.DataBind();
        }

        private void GetTeacher()
        {
            string constr = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            OracleCommand cmd = new OracleCommand();
            OracleConnection con = new OracleConnection(constr);
            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"select t.teacher_id, concat( p.first_name, concat(' ', concat( p.last_name , concat('  -  ', p.phone_number)))) as ""teacher_name"" from teacher t inner join person p on p.person_id = t.teacher_id";
            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("teacher");

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();


            DDLTeacher.DataSource = dt;
            DDLTeacher.DataTextField = "Teacher_Name";
            DDLTeacher.DataValueField = "Teacher_ID";
            DDLTeacher.DataBind();
        }

        protected void ButtonSubmit_Click(object sender, EventArgs e)
        {

            string teacher_id = DDLTeacher.SelectedValue;

            var constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            OracleCommand cmd = new OracleCommand();
            OracleConnection con = new OracleConnection(constr);

            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"select t.teacher_id, p.first_name as ""First Name"", p.last_name as ""Last Name"", p.phone_number as ""Phone Number"",
                                m.module_id as ""Module ID"", m.module_name as ""Module Name""
                                from teacher t
                                inner join person p on p.person_id = t.teacher_id
                                inner join module_teacher mt on mt.teacher_id = t.teacher_id
                                inner join module m on m.module_id = mt.module_id where t.teacher_id = '" + teacher_id + "'";

            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("Teacher");

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

            TeacherModuleGridView.DataSource = dt;
            TeacherModuleGridView.DataBind();

        }

        protected void ButtonView_Click(object sender, EventArgs e)
        {

            this.BindGrid();

        }
    }
}