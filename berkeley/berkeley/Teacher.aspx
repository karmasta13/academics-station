<%@ Page Title="Teacher" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Teacher.aspx.cs" Inherits="berkeley.WebForm3" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col d-flex nucleo text-sm">
            <div class="card flex-fill p-4 ">
                

                <div class="mb-2 text-center">
                    <h5><asp:Label ID="Label1"  runat="server" Text="Teacher Details"></asp:Label></h5>
                    <hr />
                </div>

                <div class="row form-label ">

                   <div class ="col-5">
                     <asp:Label ID="Label3" class="label" runat="server" for="TextBoxAuthor" Text="First Name * : "></asp:Label>
                    <div class ="mt-2">
                    <asp:TextBox class="form-control" ID="TeaFnameTB" runat="server" MaxLength="30" placeholder="Enter Teacher's First Name" required="true"></asp:TextBox> 
                        </div>
                    </div>

              
                   <div class ="col-5 mx-auto">
                     <asp:Label ID="Label6" class="label" runat="server" for="TextBoxAuthor" Text="Last Name : "></asp:Label>
                    <div class ="mt-2">
                    <asp:TextBox class="form-control" ID="TeaLnameTB" runat="server" placeholder="Enter Teacher's Last Name" MaxLength="30" required="true"></asp:TextBox> 
                        </div>
                    </div>

                    <div class="col-5 mt-3">
                    <asp:Label ID="Label4" class="label" runat="server" for="DateTimeDOB" Text="Date of Birth * : "></asp:Label>
                        <div class="mt-2">
                            <asp:TextBox class="form-control" textmode="Date" ID="TeaDOBTB" runat="server" required="true"></asp:TextBox>
                        </div>
                    </div>


                    <div class="col-5 mx-auto mt-3">
                    <asp:Label ID="Label5" class="label" runat="server" for="DDLGender" Text="Gender * : "></asp:Label>
                        <div class="mt-2">
                            <asp:DropDownList ID="TeaGenderTB" runat="server" class="form-control ">
                                <asp:ListItem Value="Cisgender Female">Cisgender Female</asp:ListItem>
                                <asp:ListItem Value="Cisgender Male">Cisgender Male</asp:ListItem>  
                                <asp:ListItem Value="Transgender Female">Transgender Female</asp:ListItem>
                                <asp:ListItem Value="Transgender Female">Transgender Male</asp:ListItem>                               
                                <asp:ListItem Value="Other">Others</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

            

                    <div class="col-5 mt-3">
                    <asp:Label ID="Label7" class="label" runat="server" for="TextBoxEmail" Text="Email * : "></asp:Label>
                    <div class="mt-2">
                        <asp:TextBox class="form-control" textmode="Email" ID="TeaEmailTB" placeholder="Enter Teacher's Email Address" runat="server" MaxLength="50" title="Please enter a valid Email Address." required="true"></asp:TextBox>
                    </div>
                    </div>


                    

                    <div class="col-5 mx-auto mt-3">
                    <asp:Label ID="Label8" class="label" runat="server" for="TextBoxPhoneNumber" Text="Phone Number * : "></asp:Label>
                    <div class="mt-2">
                        <asp:TextBox class="form-control" ID="TeaPhoneTB" runat="server" placeholder="Phone Number" MinLength="10" MaxLength="10" title="Please enter a valid 10 digit phone number." required="true"></asp:TextBox>
                    </div>
                    </div>


                    <div class="col-5 mt-3">
                    <asp:Label ID="Label2" class="label" runat="server" for="DateTimeDOB" Text="Hire Date * : "></asp:Label>
                        <div class="mt-2">
                            <asp:TextBox class="form-control" textmode="Date" ID="TeaHireTB"  runat="server"  required="true"></asp:TextBox>
                        </div>
                    </div>
                    

                    
                    <div class ="col-5 mx-auto mt-3">
                     <asp:Label ID="Label10" class="label" runat="server" for="TextBoxAuthor" Text="Designation * : "></asp:Label>
                    <div class ="mt-2">
                    <asp:TextBox class="form-control" ID="TeaDesignTB" runat="server" MaxLength="75" placeholder="Designation" required="true"></asp:TextBox> 
                        </div>
                    </div>
                    

                    <div class="col-5  mt-3">
                    <asp:Label ID="Label9" class="label" runat="server" for="TextBoxAuthor" Text="Salary * : "></asp:Label>
                    <div class="mt-2">
                       <asp:TextBox class="form-control" ID="TeaSalarytTB" runat="server" placeholder="Salary" MaxLength="9" pattern="[0-9]*" required="true"></asp:TextBox> 
                    </div>
                    </div>

                    <div>
                        <asp:TextBox ID="TeacherID" runat="server" Visible ="false"></asp:TextBox>
                    </div>

                </div>            
             
                
                
                

                <div class=" text-end">
                    <asp:Button ID="ButtonSubmit" runat="server" Text="Submit" class="btn btn-primary btn-lg  font-small " OnClick="ButtonSubmit_Click"/>
                </div>
            
            </div>
        </div>
  </div>  
    
    <div class="row mt-4">
        <div class="col d-flex">
            <div class="card flex-fill p-4 shadow">

                <div class="">
                    <asp:GridView   ID="TeacherGridView" runat="server" DataKeyNames="Teacher_ID" 
                                    OnRowDataBound="OnRowDataBound" 
                                    OnRowEditing="OnRowEditing" 
                                    OnRowCancelingEdit="OnRowCancelingEdit"  
                                    OnRowDeleting="OnRowDeleting" 
                                    EmptyDataText="No records has been added." 
                                    AutoGenerateEditButton="True" 
                                    AutoGenerateDeleteButton="True"
                                    class="table table-hover table-responsive border-0 text-sm border border-light">
                             

                        <RowStyle CssClass="table-responsive table-hover" />

                    </asp:GridView>
                    


                </div>
            
            </div>
        </div>
    </div>
    
</asp:Content>
