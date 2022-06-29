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
    public partial class WebForm4 : System.Web.UI.Page
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
            cmd.CommandText = @"SELECT House_ID, Country as ""Country"", City as ""City"" , Zip_Code as ""Zip Code"" FROM Address";
            cmd.CommandType = CommandType.Text;

            DataTable dt = new DataTable("Address");

            using (OracleDataReader sdr = cmd.ExecuteReader())
            {
                dt.Load(sdr);
            }

            con.Close();

            AddressGridView.DataSource = dt;
            AddressGridView.DataBind();
        }

        protected void ButtonSubmit_Click(object sender, EventArgs e)
        {

            // insert code
            string country = AddCountryTB.Text.ToString().TrimStart().TrimEnd();
            string city = AddCityTB.Text.ToString().TrimStart().TrimEnd();
            string zip_code = AddZipTB.Text.ToString().TrimStart().TrimEnd();


            string constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            OracleConnection con = new OracleConnection(constr);

            if (ButtonSubmit.Text == "Submit")
            {

                string ID = AddID.Text.ToString();
                OracleCommand cmd = new OracleCommand("Update Address set Country = '" + country + "',city = '" + city + "',zip_code = '" + zip_code + "' where House_ID = '" + ID + "'");

                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                ButtonSubmit.Text = "Submit";
                AddressGridView.EditIndex = -1;
            }

            AddCountryTB.Text = "";
            AddCityTB.Text = "";
            AddZipTB.Text = "";

            this.BindGrid();
        }


        protected void OnRowCancelingEdit(object sender, EventArgs e)
        {

            this.BindGrid();
            AddressGridView.EditIndex = -1;
        }

        protected void OnRowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string ID = AddressGridView.DataKeys[e.RowIndex].Values[0].ToString();
            string constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (OracleConnection con = new OracleConnection(constr))
            {
                using (OracleCommand cmd = new OracleCommand("DELETE FROM Address WHERE House_ID = '" + ID + "'"))
                {

                    cmd.Connection = con;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            this.BindGrid();
            AddressGridView.EditIndex = -1;

        }

        protected void OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex != AddressGridView.EditIndex)
            {
                (e.Row.Cells[0].Controls[2] as LinkButton).Attributes["onclick"] = "return confirm('Are you sure you want to delete?');";

            }
            //this.BindGrid();
            AddressGridView.EditIndex = -1;

        }

        protected void OnRowEditing(object sender, GridViewEditEventArgs e)
        {

            // get id for data update
            AddID.Text = this.AddressGridView.Rows[e.NewEditIndex].Cells[1].Text;

            AddCountryTB.Text = this.AddressGridView.Rows[e.NewEditIndex].Cells[2].Text.ToString().TrimStart().TrimEnd();
            AddCityTB.Text = this.AddressGridView.Rows[e.NewEditIndex].Cells[3].Text.ToString().TrimStart().TrimEnd();
            AddZipTB.Text = this.AddressGridView.Rows[e.NewEditIndex].Cells[4].Text.ToString().TrimStart().TrimEnd();

            ButtonSubmit.Text = "Update";

        }
    }
}