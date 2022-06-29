<%@ Page Title="Teacher_Module" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Teacher_Module.aspx.cs" Inherits="berkeley.WebForm5" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
        <div class="col d-flex text-sm">
            <div class="card flex-fill p-4">
                

                <div class="mb-2 text-center">
                    <h5><asp:Label ID="Label1"  runat="server" Text="Teacher – Module Mapping Form"></asp:Label></h5>
                    <hr />
                </div>

                <div class="form row mb-2">
                    <asp:Label ID="Label2" class="col-sm-2 col-form-label" runat="server" for="DDLTeacher" Text="Teacher (Phone No.) : "></asp:Label>
                    <div class="col-5">
                        <asp:DropDownList ID="DDLTeacher" runat="server" class="form-control font-small">
                        </asp:DropDownList>
                        </div>

                    <div class="col">
                    <asp:Button ID="ButtonSubmit" runat="server" Text="Search" class="btn btn-primary btn-md  font-small" OnClick="ButtonSubmit_Click">
                    </asp:Button>
                     </div>
                   
                </div>               

                <div class="text-end ">
                    <asp:Button ID="ButtonView" runat="server" Text="View All" class="btn btn-primary btn-lg  font-small" OnClick="ButtonView_Click">
                    </asp:Button>
                </div>   
            
            </div>
        </div>
    </div>
    
    <div class="row mt-3">
        <div class="col d-flex">
            <div class="card flex-fill p-4 shadow">

                <div class="">
                    <asp:GridView   ID="TeacherModuleGridView" runat="server" DataKeyNames="Teacher_ID" 
                                    EmptyDataText="No records found for the given teacher."
                                    class="table table-hover table-responsive border-0  text-sm border border-light">

                    </asp:GridView>
                    

                </div>
            
            </div>
        </div>
    </div>


</asp:Content>
