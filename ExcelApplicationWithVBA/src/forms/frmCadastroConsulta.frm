VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmCadastroConsulta 
   Caption         =   "Cadastro e Gerenciamento de Consultas"
   ClientHeight    =   7545
   ClientLeft      =   120
   ClientTop       =   460
   ClientWidth     =   6120
   OleObjectBlob   =   "frmCadastroConsulta.frx":0000
   StartUpPosition =   1  'CenterOwner
   Tag             =   "tbCadastroConsultas"
End
Attribute VB_Name = "frmCadastroConsulta"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub btnAlterar_Click()
    Dim oConsult As cNewConsulta
    Dim item    As Integer
    Dim IDItem As String
    
    item = Me.lstConsultas.ListIndex: If item < 0 Then Exit Sub
    IDItem = Me.lstConsultas.List(item, 0)
    
    If MsgBox("Voc� tem certeza que deseja [ALTERAR] o registro de ID: " & IDItem, vbQuestion + vbYesNo) = vbYes Then
        Set oConsult = New cNewConsulta
        Me.lstConsultas.RowSource = ""
        
        With oConsult
            .NomeProfissional = Me.txtProfissional.Value
            .CodigoProcedimento = Me.txtCodProcedimento.Value
            .cboProfissional = Me.txtCBO.Value
            .SaveOrChangeData (IDItem)
            Call ClearFields(Me)
            Me.txtProfissional.SetFocus
            Me.btnExcluir.Enabled = True
            Me.btnLancamento.Enabled = True
            Call PopulaListBox
            MsgBox "Registro alterado com sucesso.", vbInformation, Me.Caption
        End With
    End If
End Sub

Private Sub btnCancel_Click()
    Unload Me
End Sub

Private Sub btnClear_Click()
    ClearFields Me
    Me.txtProfissional.SetFocus
End Sub

Private Sub btnExcluir_Click()
    Dim item As Integer
    Dim ID   As String
    
    item = Me.lstConsultas.ListIndex: If item < 0 Then Exit Sub
    
    ID = Me.lstConsultas.List(item, 0)
    
    If MsgBox("Voc� tem certeza que deseja [EXCLUIR] o item de ID: " & ID, vbQuestion + vbYesNo) = vbYes Then
        Me.lstConsultas.RowSource = ""
        wsCadastros.ListObjects(Me.Tag).ListRows(ID).Delete
        Call PopulaListBox
        Me.btnLancamento.Enabled = True
        Me.btnExcluir.Enabled = True
        MsgBox "Registro exclu�do com sucesso.", vbInformation, Me.Caption
    End If
End Sub

Private Sub btnLancamento_Click()
    Dim oConsulta As cNewConsulta
    
    Set oConsulta = New cNewConsulta
        
    If Not ValidateEmptyControls(Me) Then
        Me.lstConsultas.RowSource = ""
        
        With oConsulta
            .NomeProfissional = Me.txtProfissional.Value
            .CodigoProcedimento = Me.txtCodProcedimento.Value
            .cboProfissional = Me.txtCBO.Value
            .SaveOrChangeData
        End With
        
        Call PopulaListBox
        Call ClearFields(Me)
        
        MsgBox "Registro efetuado com sucesso.", vbInformation, Me.Caption
    End If
End Sub

Private Sub lstConsultas_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    Dim item As Integer: item = Me.lstConsultas.ListIndex
    
    With Me
        .btnLancamento.Enabled = False
        .btnExcluir.Enabled = False
        .txtProfissional.Value = .lstConsultas.List(item, 1)
        .txtCodProcedimento.Value = .lstConsultas.List(item, 2)
        .txtCBO.Value = .lstConsultas.List(item, 3)
    End With
End Sub

Private Sub UserForm_Initialize()
    wsView.Activate
    Call PopulaListBox
End Sub

Private Sub PopulaListBox()
    Dim lo As ListObject
    Dim rng As Range
    
    Set rng = wsCadastros.ListObjects(Me.Tag).DataBodyRange
    
    With Me
        .lstConsultas.ColumnHeads = True
        .lstConsultas.ColumnCount = rng.Columns.Count
        .lstConsultas.RowSource = rng.Address(external:=1)
        .txtProfissional.SetFocus
    End With
End Sub
