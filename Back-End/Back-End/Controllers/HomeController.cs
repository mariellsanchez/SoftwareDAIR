using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;
using System.Reflection;
using Back_End.Models;
using static System.Net.Mime.MediaTypeNames;
using System.Web.UI;
using System.Web.Optimization;
using System.Web.Helpers;
using MimeKit;
using MailKit.Net.Smtp;


//using static System.Net.WebRequestMethods;

namespace Back_End.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        [Route("Home")]
        [Route("Home/Index")]
        public ActionResult Index()
        {
            return View();
        }

        [Route("Home/Menu")]
        public ActionResult Menu()
        {
            return View();
        }

        [Route("Home/Logout")]
        public ActionResult Logout()
        {
            return RedirectToAction("Index");
        }

        [Route("Home/CambiarContrasenna")]
        public ActionResult CambiarContrasenna()
        {
            return View();
        }

        [Route("Home/ValidarCambioContrasenna")]
        public ActionResult ValidarCambioContrasenna(FormCambiarContrasenna model)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CambiarContrasennia "
                    + model.Nombre + ", "
                    + model.Contrasenia + ", "
                    + model.NuevaContrasenia , con);
                int dt_response;
                dt_response = (int)cmd.ExecuteScalar();
                con.Close();
                if (dt_response == 1)
                {
                    return RedirectToAction("Index");
                }
                else if (dt_response == 0)
                {
                    return RedirectToAction("CambiarContrasenna");
                }
                else
                {
                    return RedirectToAction("CambiarContrasennia");
                }
            }
            else
            {
                return RedirectToAction("CambiarContrasennia");
            }
        }

        [HttpPost]
        public ActionResult ValidarLogin(FormLogin model) {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC IniciarSesion "
                    + model.Nombre + ", '"
                    + model.Contrasenia + "'", con);
                int dt_response;
                dt_response = (int)cmd.ExecuteScalar();
                con.Close();
                if (dt_response == 1)
                {
                    return RedirectToAction("Menu");
                }
                else if (dt_response == 0)
                {
                    return RedirectToAction("Index");
                }
                else
                {
                    return RedirectToAction("Index");
                }
            }
            else
            {
                return RedirectToAction("Index");
            }
        }

        [Route("Home/SesionesAIR")]
        public ActionResult SesionesAIR()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetSesionesAIR", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }

        [Route("Home/SesionesDAIR")]
        public ActionResult SesionesDAIR()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetSesionesDAIR", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }

        [Route("Home/SesionAIR")]
        public ActionResult SesionAIR(string id)
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionAIR " + id, conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            data.Fill(datatable);
            ViewBag.Nombre = datatable.Rows[0]["Nombre"];
            ViewBag.Fecha = datatable.Rows[0]["Fecha"];
            ViewBag.HoraInicio = datatable.Rows[0]["HoraInicio"];
            ViewBag.HoraFinal = datatable.Rows[0]["HoraFin"];
            ViewBag.SesionAIRId = id;
            SqlCommand cmd2 = new SqlCommand("EXEC GetPropuestasAIR " + id, conection);
            SqlDataAdapter data2 = new SqlDataAdapter(cmd2);
            DataTable datatable2 = new DataTable();
            data2.Fill(datatable2);
            conection.Close();
            return View(datatable2);
        }

        [Route("Home/SesionDAIR")]
        public ActionResult SesionDAIR(string id)
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionDAIR " + id, conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            data.Fill(datatable);
            ViewBag.Nombre = datatable.Rows[0]["Nombre"];
            ViewBag.Fecha = datatable.Rows[0]["Fecha"];
            ViewBag.HoraInicio = datatable.Rows[0]["HoraInicio"];
            ViewBag.HoraFinal = datatable.Rows[0]["HoraFin"];
            ViewBag.SesionDAIRId = id;
            SqlCommand cmd2 = new SqlCommand("EXEC GetPropuestasDAIR " + id, conection);
            SqlDataAdapter data2 = new SqlDataAdapter(cmd2);
            DataTable datatable2 = new DataTable();
            data2.Fill(datatable2);
            conection.Close();
            return View(datatable2);
        }

        [Route("Home/CrearSesionAIR")]
        public ActionResult CrearSesionAIR()
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Periodo;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows) {
                items.Add(new SelectListItem { Text = row["AnioInicio"].ToString() + " - " + row["AnioFin"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.Periodo = items;
            ViewBag.Validacion = false;
            return View();
        }

        [HttpPost]
        public ActionResult CrearSesionAIR(FormCrearSesionAIR model) {
            if (ModelState.IsValid)
            {
                string path = "";
                try
                {
                    if (model.ArchivoPadron.ContentLength > 0)
                    {
                        string _FileName = Path.GetFileName(model.ArchivoPadron.FileName);
                        string _path = Path.Combine(Server.MapPath("~/UploadedFiles"), _FileName);
                        model.ArchivoPadron.SaveAs(_path);
                        path = _path;
                    }
                    ViewBag.Message = "File Uploaded Successfully!!";
                    //return View();
                }
                catch
                {
                    ViewBag.Message = "File upload failed!!";
                    //return View();
                }

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreateSesionAIR "
                    + model.Periodo + ", '"
                    + model.Nombre + "', '"
                    + model.Fecha + "', '"
                    + model.TiempoInicial + "', '"
                    + model.TiempoFinal + "'", con);
                var temp = cmd.ExecuteScalar();
                SqlCommand cmd2 = new SqlCommand("EXEC NuevoRegistroAIR " + Convert.ToString(temp) +
                                                ", '" + path + "', '" +
                                                model.NombrePadron + "'");
                cmd2.Connection = con;
                cmd2.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //DataTable dt = new DataTable();
                con.Close();
                //da.Fill(dt);
                return RedirectToAction("SesionesAIR");
            }
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd3 = new SqlCommand("SELECT * FROM dbo.Periodo;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd3);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["AnioInicio"].ToString() + " - " + row["AnioFin"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.Periodo = items;
            ViewBag.Validacion = true;
            return View(model);
        }

        [Route("Home/CrearSesionDAIR")]
        public ActionResult CrearSesionDAIR()
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Periodo;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["AnioInicio"].ToString() + " - " + row["AnioFin"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.Periodo = items;
            return View();
        }

        [HttpPost]
        public ActionResult CrearSesionDAIR(FormCrearSesionDAIR model)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreateSesionDAIR "
                    + model.Periodo + ", '"
                    + model.Nombre + "', '"
                    + model.Fecha + "', '"
                    + model.TiempoInicial + "', '"
                    + model.TiempoFinal + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
                return RedirectToAction("SesionesDAIR");
            }
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd2 = new SqlCommand("SELECT * FROM dbo.Periodo;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd2);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["AnioInicio"].ToString() + " - " + row["AnioFin"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.Periodo = items;
            return View();
        }


        [Route("Home/Propuesta")]
        // https://stackoverflow.com/questions/11100981/asp-net-mvc-open-pdf-file-in-new-window
        public ActionResult Propuesta(string path)
        {
            return File(path, "application/pdf");
        }

        [Route("Home/EditarSesionAIR")]
        // https://stackoverflow.com/questions/11100981/asp-net-mvc-open-pdf-file-in-new-window
        public ActionResult EditarSesionAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombreSesionAIR = dt.Rows[0]["Nombre"];
            ViewBag.Id = dt.Rows[0]["Id"].ToString();
            return View();
            //return File(path, "application/pdf");
        }

        [HttpPost]
        public ActionResult EditarSesionAIR(FormEditarDetallesSesionAIR model)
        {
            if (ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                string path = "";
                try
                {
                    if (model.ArchivoPadron.ContentLength > 0)
                    {
                        string _FileName = Path.GetFileName(model.ArchivoPadron.FileName);
                        string _path = Path.Combine(Server.MapPath("~/UploadedFiles"), _FileName);
                        model.ArchivoPadron.SaveAs(_path);
                        path = _path;
                    }
                    ViewBag.Message = "File Uploaded Successfully!!";
                    //return View();
                }
                catch
                {
                    ViewBag.Message = "File upload failed!!";
                    //return View();
                }
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC UpdateSesionAIR " + model.Id +
                                                ", '" + model.Nombre + "', '" +
                                                model.Fecha + "', '" +
                                                model.TiempoInicial + "', '" +
                                                model.TiempoFinal +"'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                SqlCommand cmd2 = new SqlCommand("EXEC NuevoRegistroAIR " + model.Id +
                                                ", '" + path + "', '" +
                                                model.NombrePadron + "'");
                cmd2.Connection = con;
                cmd2.ExecuteNonQuery();
                //SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
                //DataTable dt2 = new DataTable();
                con.Close();
                da.Fill(dt);
                return RedirectToAction("SesionesAIR");
                //da2.Fill(dt2);
            }
            SqlConnection con2 = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con2.Open();
            SqlCommand cmd3 = new SqlCommand("EXEC ReadSesionAIR " + model.Id, con2);
            SqlDataAdapter da2 = new SqlDataAdapter(cmd3);
            DataTable dt2 = new DataTable();
            con2.Close();
            da2.Fill(dt2);
            ViewBag.NombreSesionAIR = dt2.Rows[0]["Nombre"];
            ViewBag.LinkAIR = dt2.Rows[0]["Link"];
            ViewBag.Id = dt2.Rows[0]["Id"].ToString();
            return View();
        }

        [Route("Home/EditarSesionDAIR")]
        // https://stackoverflow.com/questions/11100981/asp-net-mvc-open-pdf-file-in-new-window
        public ActionResult EditarSesionDAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionDAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombreSesionDAIR = dt.Rows[0]["Nombre"];
            //ViewBag.LinkDAIR = dt.Rows[0]["Link"];
            ViewBag.Id = dt.Rows[0]["Id"].ToString();
            return View();
            //return File(path, "application/pdf");
        }

        [HttpPost]
        public ActionResult EditarSesionDAIR(FormEditarDetallesSesionDAIR model)
        {
            if (ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC UpdateSesionDAIR " + model.Id + ", '" + model.Nombre + "', '" + model.Fecha + "', '" + model.TiempoInicial + "', '" + model.TiempoFinal  + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
                return RedirectToAction("SesionesDAIR");
            }
            SqlConnection con2 = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con2.Open();
            SqlCommand cmd2 = new SqlCommand("EXEC ReadSesionDAIR " + model.Id, con2);
            SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
            DataTable dt2 = new DataTable();
            con2.Close();
            da2.Fill(dt2);
            ViewBag.NombreSesionDAIR = dt2.Rows[0]["Nombre"];
            //ViewBag.LinkDAIR = dt.Rows[0]["Link"];
            ViewBag.Id = dt2.Rows[0]["Id"].ToString();
            return View();
        }

        public ActionResult BorrarSesionAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeleteSesionAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("SesionesAIR");
        }

        public ActionResult BorrarSesionDAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeleteSesionDAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("SesionesDAIR");
        }

        public ActionResult PropuestaAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombreSesionAIR = dt.Rows[0]["Nombre"];
            ViewBag.Id = dt.Rows[0]["Id"].ToString();
            return View();
        }

        public ActionResult VerPropuestaAIR(String link)
        {
            return Redirect("http://" + link);
            return RedirectToAction("SesionesAIR");
        }

        public ActionResult BorrarPropuestaAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeletePropuestaAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("SesionesAIR");
        }

        [Route("Home/EditarPropuestaAIR")]
        public ActionResult EditarPropuestaAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            SqlCommand cmd1 = new SqlCommand("SELECT * FROM dbo.Etapa;", con);
            SqlDataAdapter data = new SqlDataAdapter(cmd1);
            DataTable datatable = new DataTable();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["Nombre"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.EtapaId = items;
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadPropuestaAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombrePropuestaAIR = dt.Rows[0]["Nombre1"];
            ViewBag.ID = id;
            ViewBag.Link = dt.Rows[0]["Link"];
            ViewBag.NumeroPropuesta = dt.Rows[0]["NumeroDePropuesta"];
            ViewBag.VotosFavor = dt.Rows[0]["VotosAFavor"];
            ViewBag.VotosContra = dt.Rows[0]["VotosEnContra"];
            ViewBag.VotosBlanco = dt.Rows[0]["VotosEnBlanco"];
            return View();
        }

        //EDITAR PROPUESTA DAIR
        [Route("Home/EditarPropuestaDAIR")]
        public ActionResult EditarPropuestaDAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadPropuestaDAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombrePropuestaDAIR = dt.Rows[0]["Nombre"];
            ViewBag.ID = id;
            ViewBag.Link = dt.Rows[0]["Link"];
            return View();
        }

        [HttpPost]
        public ActionResult EditarPropuestaAIR(FormEditarPropuestaAIR model)
        {
            if (!ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();

                SqlCommand cmd = new SqlCommand("EXEC UpdatePropuestaAIR "
                    + model.Id + ", '"
                    + model.EtapaId + "', '"
                    + model.Aprovado + "', '"
                    + model.Nombre + "', '"
                    + model.Link + "', '"
                    + model.NumeroPropuesta + "', '"
                    + model.VotosFavor + "', '"
                    + model.VotosContra + "', '"
                    + model.VotosBlanco + "'", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
            }
            SqlConnection con2 = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            SqlCommand cmd2 = new SqlCommand("SELECT * FROM dbo.Etapa;", con2);
            SqlDataAdapter data = new SqlDataAdapter(cmd2);
            DataTable datatable = new DataTable();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["Nombre"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.EtapaId = items;
            con2.Open();
            SqlCommand cmd4 = new SqlCommand("EXEC ReadPropuestaAIR " + model.Id, con2);
            SqlDataAdapter da2 = new SqlDataAdapter(cmd4);
            DataTable dt2 = new DataTable();
            con2.Close();
            da2.Fill(dt2);
            ViewBag.NombrePropuestaAIR = dt2.Rows[0]["Nombre1"];
            ViewBag.ID = model.Id;
            ViewBag.Link = dt2.Rows[0]["Link"];
            ViewBag.NumeroPropuesta = dt2.Rows[0]["NumeroDePropuesta"];
            ViewBag.VotosFavor = dt2.Rows[0]["VotosAFavor"];
            ViewBag.VotosContra = dt2.Rows[0]["VotosEnContra"];
            ViewBag.VotosBlanco = dt2.Rows[0]["VotosEnBlanco"];
            return View();
        }


        //BORRAR PROPUESTA DAIR
        public ActionResult BorrarPropuestaDAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeletePropuestaDAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("SesionesDAIR");
        }

        //CREAR PROPUESTA AIR
        [Route("Home/CrearPropuestaDAIR")]
        public ActionResult CrearPropuestaDAIR(String SesionDAIRId)
        {
            ViewBag.SesionDAIRId = SesionDAIRId.ToString();
            List<SelectListItem> items_aprovado = new List<SelectListItem>();
            items_aprovado.Add(new SelectListItem { Text = "Sí", Value = "1" });
            items_aprovado.Add(new SelectListItem { Text = "No", Value = "0" });
            ViewBag.Aprovado = items_aprovado;
            return View();
        }

        [HttpPost]
        public ActionResult CrearPropuestaDAIR(FormCrearPropuestaDAIR model)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreatePropuestaDAIR "
                    + model.Id + ", '"
                    + model.Nombre + "', '"
                    + model.Aprovado + "', '"
                    + model.Link + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
                return RedirectToAction("SesionesDAIR");
            }
            ViewBag.SesionDAIRId = model.Id.ToString();
            List<SelectListItem> items_aprovado = new List<SelectListItem>();
            items_aprovado.Add(new SelectListItem { Text = "Sí", Value = "1" });
            items_aprovado.Add(new SelectListItem { Text = "No", Value = "0" });
            ViewBag.Aprovado = items_aprovado;
            return View();
        }

        //CREAR PROPUESTA AIR
        [Route("Home/CrearPropuestaAIR")]
        public ActionResult CrearPropuestaAIR(String SesionAIRId)
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Etapa;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["Nombre"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.EtapaId = items;
            ViewBag.SesionAIRId = SesionAIRId;
            List<SelectListItem> items_aprovado = new List<SelectListItem>();
            items_aprovado.Add(new SelectListItem { Text = "Sí", Value = "1" });
            items_aprovado.Add(new SelectListItem { Text = "No", Value = "0" });
            ViewBag.Aprovado = items_aprovado;
            return View();
        }

        [HttpPost]
        public ActionResult CrearPropuestaAIR(FormCrearPropuestaAIR model)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreatePropuestaAIR "
                    + model.Id + ", '"
                    + model.EtapaId + "', '"
                    + model.Aprovado + "', '"
                    + model.Nombre + "', '"
                    + model.Link + "', '"
                    + model.NumeroPropuesta + "', '"
                    + model.VotosFavor + "', '"
                    + model.VotosContra + "', '"
                    + model.VotosBlanco + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
                return RedirectToAction("SesionAIR/" + model.Id.ToString());
            }
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd2 = new SqlCommand("SELECT * FROM dbo.Etapa;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd2);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["Nombre"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.EtapaId = items;
            ViewBag.SesionAIRId = model.Id;
            List<SelectListItem> items_aprovado = new List<SelectListItem>();
            items_aprovado.Add(new SelectListItem { Text = "Sí", Value = "1" });
            items_aprovado.Add(new SelectListItem { Text = "No", Value = "0" });
            ViewBag.Aprovado = items_aprovado;
            return View();
        }


        [HttpPost]
        public ActionResult EnviarEdicionPropuestaAIR(FormEditarPropuestaAIR model)
        {

            if (!ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();

                SqlCommand cmd1 = new SqlCommand("EXEC ReadPropuestaAIR " + model.Id, con);
                SqlDataAdapter da1 = new SqlDataAdapter(cmd1);
                DataTable dt1 = new DataTable();
                da1.Fill(dt1);
                SqlCommand cmd = new SqlCommand("EXEC UpdatePropuestaAIR "
                    + model.Id + ", '"
                    + model.EtapaId + "', '"
                    + model.Aprovado + "', '"
                    + model.Nombre + "', '"
                    + model.Link + "', '"
                    + model.NumeroPropuesta + "', '"
                    + model.VotosFavor + "', '"
                    + model.VotosContra + "', '"
                    + model.VotosBlanco + "'", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);


                SqlCommand cmd2 = new SqlCommand("SELECT * FROM dbo.PropuestaAIR WHERE Id=" + model.Id, con);

                SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
                DataTable dt2 = new DataTable();
                da2.Fill(dt2);

                con.Close();
                return RedirectToAction("SesionAIR/" + dt2.Rows[0]["SesionAIRId"].ToString());

            }
            return RedirectToAction("SesionesAIR");
        }

        [HttpPost]
        public ActionResult EnviarEdicionPropuestaDAIR(FormEditarPropuestaDAIR model)
        {
            if (!ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();

                SqlCommand cmd = new SqlCommand("EXEC UpdatePropuestaDAIR "
                    + model.Id + ", '"
                    + model.Nombre + "', '"
                    + model.Aprovado + "', '"
                    + model.Link + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
              
                da.Fill(dt);

                SqlCommand cmd2 = new SqlCommand("SELECT * FROM dbo.PropuestaDAIR WHERE Id=" + model.Id, con);

                SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
                DataTable dt2 = new DataTable();
                da2.Fill(dt2);
                con.Close();
                return RedirectToAction("SesionDAIR/" + dt2.Rows[0]["SesionDAIRId"].ToString());
            }
            return RedirectToAction("SesionesDAIR");
        }

        //CONSTANCIAS
        [Route("Home/Constancias")]
        public ActionResult Constancias()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetAsambleistas", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }

        [Route("Home/ConstanciaAsambleista")]
        public ActionResult ConstanciaAsambleista(int id)
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();

            //Información de Asambleista
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Asambleista WHERE Id=" + id, conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            data.Fill(datatable);
            ViewBag.Nombre = datatable.Rows[0]["Nombre"];
            ViewBag.Cedula = datatable.Rows[0]["Cedula"];
            ViewBag.Sede = datatable.Rows[0]["SedeId"];
            //DEPARTAMENTO
            SqlCommand cmd1 = new SqlCommand("SELECT * FROM dbo.Departamento WHERE Id=" + datatable.Rows[0]["DepartamentoID"], conection);
            SqlDataAdapter data1 = new SqlDataAdapter(cmd1);
            DataTable datatable1 = new DataTable();
            data1.Fill(datatable1);
            ViewBag.Departamento = datatable1.Rows[0]["Nombre"];
            //SECTOR  SECTOR
            SqlCommand cmd2 = new SqlCommand("SELECT * FROM dbo.Sector WHERE Id=" + datatable.Rows[0]["SectorId"], conection);
            SqlDataAdapter data2 = new SqlDataAdapter(cmd2);
            DataTable datatable2 = new DataTable();
            data2.Fill(datatable2);
            ViewBag.Sector = datatable2.Rows[0]["Nombre"];
            //SEDE     SEDE     SEDE
            SqlCommand cmd3 = new SqlCommand("SELECT * FROM dbo.Sede WHERE Id=" + datatable.Rows[0]["SedeId"], conection);
            SqlDataAdapter data3 = new SqlDataAdapter(cmd3);
            DataTable datatable3 = new DataTable();
            data3.Fill(datatable3);
            ViewBag.Sede = datatable3.Rows[0]["Nombre"];

            //SESIONES A LAS QUE DEBIO ASISTIR r           
            SqlCommand cmd4 = new SqlCommand("EXEC GetAsistenciaAsambleista " + datatable.Rows[0]["Cedula"], conection);
            SqlDataAdapter data4 = new SqlDataAdapter(cmd4);
            DataTable datatable4 = new DataTable();
            data4.Fill(datatable4);
            datatable4.Columns.Add("NombreP", typeof(String));

            foreach (DataRow row in datatable4.Rows)
            {
                SqlCommand cmd5 = new SqlCommand("SELECT * FROM dbo.Periodo WHERE Id=" + row["PeriodoId"], conection);
                SqlDataAdapter data5 = new SqlDataAdapter(cmd5);
                DataTable datatable5 = new DataTable();
                data5.Fill(datatable5);
                row["NombreP"] = datatable5.Rows[0]["AnioInicio"].ToString() + " - " + datatable5.Rows[0]["AnioFin"].ToString();
            }
            conection.Close();
            return View(datatable4);
        }

        public ActionResult AsistenciaAIR()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetSesionesAIR", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }


        public ActionResult ActualizarAsistencia(FromViewModelAsistencia model)
        {
            string path = "";
            try
            {
                if (model.asistencia.ArchivoPadron.ContentLength > 0)
                {
                    string _FileName = Path.GetFileName(model.asistencia.ArchivoPadron.FileName);
                    string _path = Path.Combine(Server.MapPath("~/UploadedFiles"), _FileName);
                    model.asistencia.ArchivoPadron.SaveAs(_path);
                    path = _path;
                }
                ViewBag.Message = "File Uploaded Successfully!!";
                //return View();
            }
            catch
            {
                ViewBag.Message = "File upload failed!!";
                //return View();
            }
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ActualizarRegistroAIR " + model.Id +
                                            ", '" + path + "', '" +
                                            model.asistencia.NombrePadron + "'");
            cmd.Connection = con;
            cmd.ExecuteNonQuery();
            //SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
            //DataTable dt2 = new DataTable();
            con.Close();
            return RedirectToAction("AsistenciaAIR");
     }

    public ActionResult AsistenciaSesionAIR(int id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand($"EXEC GetAsistenciaSesionAIR {id}", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            FromViewModelAsistencia mymodel = new FromViewModelAsistencia();
            mymodel.datatable = dt;
            ViewBag.Id=id;
            return View(mymodel);
        }

        [Route("Home/PadronesAIR")]
        public ActionResult PadronesAIR()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetPeriodo", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }

        [Route("Home/PadronAIR")]
        public ActionResult PadronAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetPadron " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            SqlCommand cmd2 = new SqlCommand("EXEC ReadPeriodo " + id, con);
            SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
            DataTable dt2 = new DataTable();

            con.Close();
            da.Fill(dt);
            da2.Fill(dt2);
            ViewBag.Nombre = "Padrón " + dt2.Rows[0]["AnioInicio"] + "-" + dt2.Rows[0]["AnioFin"];
            return View(dt);
        }

        [Route("Home/CrearPadronAIR")]
        public ActionResult CrearPadronAIR()
        {
            return View();
        }

        [HttpPost]
        public ActionResult GuardarNuevoPadronAIR(FormCrearPadron model)
        {
            if (ModelState.IsValid)
            {
                string path = "";
                try
                {
                    if (model.ArchivoPadron.ContentLength > 0)
                    {
                        string _FileName = Path.GetFileName(model.ArchivoPadron.FileName);
                        string _path = Path.Combine(Server.MapPath("~/UploadedFiles"), _FileName);
                        model.ArchivoPadron.SaveAs(_path);
                        path = _path;
                    }
                    ViewBag.Message = "File Uploaded Successfully!!";
                    //return View();
                }
                catch
                {
                    ViewBag.Message = "File upload failed!!";
                    //return View();
                }
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreatePeriodo " +
                    model.AnioInicio + ", " +
                    model.AnioFin);
                cmd.Connection = con;
                var temp = cmd.ExecuteScalar();
                SqlCommand cmd2 = new SqlCommand("EXEC NuevoPadronAIR " + Convert.ToString(temp) +
                                                ", '" + path + "', '" +
                                                model.NombrePadron + "'");
                cmd2.Connection = con;
                cmd2.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //DataTable dt = new DataTable();
                con.Close();
                //da.Fill(dt);
            }
            return RedirectToAction("PadronesAIR");
        }

        [Route("Home/EditarPadronAIR")]
        public ActionResult EditarPadronAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadPeriodo " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.Id = id;
            ViewBag.AnioInicio = dt.Rows[0]["AnioInicio"];
            ViewBag.AnioFin = dt.Rows[0]["AnioFin"];
            FromViewModelPadron mymodel = new FromViewModelPadron();
            mymodel.datatable = dt;
            return View(mymodel);
        }

        [HttpPost]
        public ActionResult EnviarEdicionPadronAIR(FromViewModelPadron model)
        {
            if (ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                string path = "";
                try
                {
                    if (model.padron.ArchivoPadron.ContentLength > 0)
                    {
                        string _FileName = Path.GetFileName(model.padron.ArchivoPadron.FileName);
                        string _path = Path.Combine(Server.MapPath("~/UploadedFiles"), _FileName);
                        model.padron.ArchivoPadron.SaveAs(_path);
                        path = _path;
                    }
                    ViewBag.Message = "File Uploaded Successfully!!";
                    //return View();
                }
                catch
                {
                    ViewBag.Message = "File upload failed!!";
                    //return View();
                }
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC NuevoPadronAIR " + model.Id +
                                                ", '" + path + "', '" +
                                                model.padron.NombrePadron + "'");
                cmd.Connection = con;
                cmd.ExecuteNonQuery();

                SqlCommand cmd2 = new SqlCommand("EXEC UpdatePeriodo " + model.Id +
                                                ", " + model.padron.AnioInicio + ", " +
                                                model.padron.AnioFin);
                cmd2.Connection = con;
                cmd2.ExecuteNonQuery();
                //SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
                //DataTable dt2 = new DataTable();
                con.Close();
                //da.Fill(dt);
                //da2.Fill(dt2);
            }
            return RedirectToAction("PadronesAIR");
        }

        [Route("Home/Notificaciones")]
        public ActionResult Notificaciones()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetNotificaciones", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }

        //CREAR NOTIFICACION
        [Route("Home/CrearNotificacion")]
        public ActionResult CrearNotificacion()
        {
            return View();
        }

        [HttpPost]
        public ActionResult GuardarNuevaNotificacion(FormCrearNotificacion model)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreateNotificacion '"
                    + model.Descripcion + "', '"
                    + model.Fecha + "' ", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);

                NewNotificationEmail(model.Descripcion, model.Fecha);
            }
            return RedirectToAction("Notificaciones");
        }

        [HttpPost]
        public ActionResult GuardarEdicionNotificacion(FormEditarNotificacion model)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC UpdateNotificacion "
                    + model.Id + ", '"
                    + model.Descripcion + "', '"
                    + model.Fecha + "' ", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
                EditedNotificationEmail(model.Descripcion, model.Fecha);
            }
            return RedirectToAction("Notificaciones");
        }


        [Route("Home/EditarNotificacion")]
        // https://stackoverflow.com/questions/11100981/asp-net-mvc-open-pdf-file-in-new-window
        public ActionResult EditarNotificacion(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadNotificacion " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.ID = id;
            ViewBag.Motivo = dt.Rows[0]["Motivo"];
            ViewBag.FechaNotificacion = dt.Rows[0]["FechaNotificacion"];
            return View();
            //return File(path, "application/pdf");
        }

        public ActionResult BorrarNotificacion(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeleteNotificacion " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("Notificaciones");
        }

        public void NewNotificationEmail(string desc, string fecha) {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("Recordarios DAIR", "softwaredair@outlook.com"));
            message.To.Add(new MailboxAddress("Secretaria DAIR", "mariellsanchez99@gmail.com"));
            message.Subject = "Nuevo recordatorio añadido";
            message.Body = new TextPart("plain") 
            {
                Text = "Hola! Se ha añadido un nuevo recordatorio. Descripción:" + desc + ". Fecha: " + fecha
            };
            using (var client = new SmtpClient () )
            {
                client.Connect("smtp.office365.com", 587, false);
                client.Authenticate("softwaredair@outlook.com", "Dair-2022");
                client.Send(message);
                client.Disconnect(true);
            }
        }

        public void EditedNotificationEmail(string desc, string fecha)
        {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("Recordarios DAIR", "softwaredair@outlook.com"));
            message.To.Add(new MailboxAddress("Secretaria DAIR", "mariellsanchez99@gmail.com"));
            message.Subject = "Recordatorio editado";
            message.Body = new TextPart("plain")
            {
                Text = "Hola! Se ha editado un recordatorio. Descripción:" + desc + ". Fecha: " + fecha
            };
            using (var client = new SmtpClient())
            {
                client.Connect("smtp.office365.com", 587, false);
                client.Authenticate("softwaredair@outlook.com", "Dair-2022");
                client.Send(message);
                client.Disconnect(true);
            }
        }
    }

}