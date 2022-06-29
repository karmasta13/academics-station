<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="berkeley.WebForm8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid py-4">
      <div class="row">
        <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
          <div class="card">
            <div class="card-body p-3">
              <div class="row">
                <div class="col-8">
                  <div class="numbers">
                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Total Students</p>
                    <h5 class="font-weight-bolder text-primary  font-weight-bolder mt-2" ID="StudentCount" runat="server">
                    </h5>
                    
                  </div>
                </div>
                <div class="col-4 text-end">
                  <div class="icon icon-shape bg-gradient-primary shadow-primary text-center rounded-circle">
                    <i class="fa fa-user-friends text-lg opacity-10" aria-hidden="true"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
          <div class="card">
            <div class="card-body p-3">
              <div class="row">
                <div class="col-8">
                  <div class="numbers">
                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Total Teachers</p>
                    <h5 class="font-weight-bolder text-primary  font-weight-bolder mt-2" ID="TeacherCount" runat="server">
                    
                    </h5>
                    
                  </div>
                </div>
                <div class="col-4 text-end">
                  <div class="icon icon-shape bg-gradient-danger shadow-danger text-center rounded-circle">
                    <i class="fa fa-chalkboard-teacher text-lg opacity-10" aria-hidden="true"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
          <div class="card">
            <div class="card-body p-3">
              <div class="row">
                <div class="col-8">
                  <div class="numbers">
                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Total Module</p>
                    <h5 class="font-weight-bolder text-primary  font-weight-bolder mt-2" ID="ModuleCount" runat="server">
                    
                    </h5>
                    
                  </div>
                </div>
                <div class="col-4 text-end">
                  <div class="icon icon-shape bg-gradient-primary shadow-success text-center rounded-circle">
                    <i class="fa fa-book text-lg opacity-10" aria-hidden="true"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6">
          <div class="card">
            <div class="card-body p-3">
              <div class="row">
                <div class="col-8">
                  <div class="numbers">
                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Total Department</p>
                    <h5 class="font-weight-bolder text-primary  font-weight-bolder mt-2" ID="DepartmentCount" runat="server">
                    
                    </h5>
                    
                  </div>
                </div>
                <div class="col-4 text-end">
                  <div class="icon icon-shape bg-gradient-warning shadow-warning text-center rounded-circle">
                    <i class="fa fa-building text-lg opacity-10" aria-hidden="true"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
     </div>

    

       <div class="row mt-2 mx-2">
        <div class="col-lg-7 mb-lg-0 mb-4">
          <div class="card z-index-2 h-100">
            <div class="card-header pb-0 pt-3 bg-transparent">
              <h6 class="text-capitalize">Fee overview</h6>
              
            </div>
            <div class="card-body p-3">
              <div class="chart">
                <canvas id="line-chart-gradient" class="chart-canvas" height="300"></canvas>
              </div>
            </div>
          </div>
        </div>
       

        <div class="card col">
            <div class="card-header pb-0 pt-3 bg-transparent">
              <h6 class="text-capitalize">Gender overview</h6>
              
            </div>
            <div class="card-body p-3">
                <div class="chart">
                    <canvas id="pie-chart" class="chart-canvas"></canvas>
                 </div>
            </div>
        </div>



    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="JavaScriptContent" runat="server">
  <script>
    
      // Line chart with gradient
      var ctx2 = document.getElementById("line-chart-gradient").getContext("2d");

      var gradientStroke1 = ctx2.createLinearGradient(0, 230, 0, 50);

      gradientStroke1.addColorStop(1, 'rgba(94,114,228,0.2)');
      gradientStroke1.addColorStop(0.2, 'rgba(72,72,176,0.0)');
      gradientStroke1.addColorStop(0, 'rgba(94,114,228,0)'); //purple colors

      var gradientStroke2 = ctx2.createLinearGradient(0, 230, 0, 50);

      gradientStroke2.addColorStop(1, 'rgba(20,23,39,0.2)');
      gradientStroke2.addColorStop(0.2, 'rgba(72,72,176,0.0)');
      gradientStroke2.addColorStop(0, 'rgba(20,23,39,0)'); //purple colors

      new Chart(ctx2, {
        type: "line",
        data: {
          labels: <%=YearLabels%>,
          datasets: [{
              label: "Fee (NPR.)",
              tension: 0.4,
              borderWidth: 0,
              pointRadius: 0,
              borderColor: "#5e72e4",
              borderWidth: 3,
              backgroundColor: gradientStroke1,
              fill: true,
              data: <%=FeeCollection%>,
              maxBarThickness: 6

            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: false,
            }
          },
          interaction: {
            intersect: false,
            mode: 'index',
          },
          scales: {
            y: {
              grid: {
                drawBorder: false,
                display: true,
                drawOnChartArea: true,
                drawTicks: false,
                borderDash: [5, 5]
              },
              ticks: {
                display: true,
                padding: 10,
                color: '#b2b9bf',
                font: {
                  size: 11,
                  family: "Open Sans",
                  style: 'normal',
                  lineHeight: 2
                },
              }
            },
            x: {
              grid: {
                drawBorder: false,
                display: false,
                drawOnChartArea: false,
                drawTicks: false,
                borderDash: [5, 5]
              },
              ticks: {
                display: true,
                color: '#b2b9bf',
                padding: 10,
                font: {
                  size: 11,
                  family: "Open Sans",
                  style: 'normal',
                  lineHeight: 2
                },
              }
            },
          },
        },
      });

      // Pie chart
      var ctx4 = document.getElementById("pie-chart").getContext("2d");

      new Chart(ctx4, {
        type: "pie",
        data: {
          labels: <%=GenderLabels%>,
          datasets: [{
            label: "Gender",
            weight: 9,
            cutout: 0,
            tension: 0.9,
            pointRadius: 2,
            borderWidth: 2,
              backgroundColor: ['#17c1e8', '#5e72e4', '#3A416F', '#F5494B','#FB8440' ],
            data: <%=GenderDistribution%>,
            fill: false
          }],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: false,
            }
          },
          interaction: {
            intersect: false,
            mode: 'index',
          },
          scales: {
            y: {
              grid: {
                drawBorder: false,
                display: false,
                drawOnChartArea: false,
                drawTicks: false,
              },
              ticks: {
                display: false
              }
            },
            x: {
              grid: {
                drawBorder: false,
                display: false,
                drawOnChartArea: false,
                drawTicks: false,
              },
              ticks: {
                display: false,
              }
            },
          },
        },
      });
  </script>
</asp:Content>