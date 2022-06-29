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
    public partial class WebForm8 : System.Web.UI.Page
    {
        public string YearLabels;
        public string FeeCollection;
        public string GenderLabels;
        public string GenderDistribution;

        protected void Page_Load(object sender, EventArgs e)
        {
            // default load data
            if (!this.IsPostBack)
            {
                this.PopulateCard();
                this.PlotYearlyFeeLineChart();
                this.PlotGenderDistributionPieChart();
            }
        }

        private void PopulateCard()
        {

            var constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            OracleCommand cmd = new OracleCommand();
            OracleConnection con = new OracleConnection(constr);

            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"SELECT COUNT(*) FROM Student";
            cmd.CommandType = CommandType.Text;
            OracleDataReader dr = cmd.ExecuteReader();
            dr.Read();
            int count = Convert.ToInt32(dr[0]);
            con.Close();

            StudentCount.InnerText = count.ToString();



            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"SELECT COUNT(*) FROM Teacher";
            cmd.CommandType = CommandType.Text;
            dr = cmd.ExecuteReader();
            dr.Read();
            count = Convert.ToInt32(dr[0]);
            con.Close();

            TeacherCount.InnerText = count.ToString();



            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"SELECT COUNT(*) FROM Module";
            cmd.CommandType = CommandType.Text;
            dr = cmd.ExecuteReader();
            dr.Read();
            count = Convert.ToInt32(dr[0]);
            con.Close();

            ModuleCount.InnerText = count.ToString();



            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"SELECT COUNT(*) FROM Department";
            cmd.CommandType = CommandType.Text;
            dr = cmd.ExecuteReader();
            dr.Read();
            count = Convert.ToInt32(dr[0]);
            con.Close();

            DepartmentCount.InnerText = count.ToString();

        }


        private void PlotYearlyFeeLineChart()
        {
            var constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            OracleCommand cmd = new OracleCommand();
            OracleConnection con = new OracleConnection(constr);

            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"SELECT SUM(fee_amount), Extract(year from Payment_date) as year FROM fee_detail GROUP BY Extract(year from Payment_date) order by Extract(year from Payment_date)";
            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable();

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();

            YearLabels = "[ ";
            FeeCollection = "[ ";

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                YearLabels += dt.Rows[i]["year"].ToString() + ",";
                FeeCollection += dt.Rows[i]["SUM(fee_amount)"].ToString() + ",";
            }

            YearLabels += " ]";
            FeeCollection += " ]";
        }


        private void PlotGenderDistributionPieChart()
        {
            var constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            OracleCommand cmd = new OracleCommand();
            OracleConnection con = new OracleConnection(constr);

            con.Open();
            cmd.Connection = con;
            cmd.CommandText = @"select count(*) as total, gender from person group by gender order by gender";
            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable();

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();

            GenderLabels = "[ ";
            GenderDistribution = "[ ";

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                GenderLabels += "'"+dt.Rows[i]["gender"].ToString() + "',";
                GenderDistribution += dt.Rows[i]["total"].ToString() + ",";
            }

            GenderLabels += " ]";
            GenderDistribution += " ]";
        }
    }
}