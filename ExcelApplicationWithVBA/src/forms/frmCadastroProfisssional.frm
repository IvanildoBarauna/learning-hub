VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmCadastroProfissional 
   Caption         =   "Cadastro e Gerenciamento de Profissionais"
   ClientHeight    =   7545
   ClientLeft      =   120
   ClientTop       =   460
   ClientWidth     =   6120
   OleObjectBlob   =   "frmCadastroProfisssional.frx":0000
   StartUpPosition =   1  'CenterOwner
   Tag             =   "tbCadastroProfissional"
End
Attribute VB_Name = "frmCadastroProfissional"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub btnAlterar_Click()
    Dim oProf As cNewProfissional
    Dim item    As Integer
    Dim IDItem As String
    
    item = Me.lstProfissionais.ListIndex: If item < 0 Then Exit Sub
    
    IDItem = Me.lstProfissionais.List(item, 0)
    
    If MsgBox("Voc� tem certeza que deseja [ALTERAR] o registro de ID: " & IDItem, vbQuestion + vbYesNo) = vbYes Then
        Set oProf = New cNewProfissional
        Me.lstProfissionais.RowSource = ""
        
        With oProf
            .NomeProfissional = Me.txtProfissional.Value
            .cboProfissional = Me.txtCBO.Value
            .SaveOrChangeData (IDItem)
            Call ClearFields(Me)
            Call PopulaListBox
            Me.btnLancamento.Enabled = True
            Me.btnExcluir.Enabled = True
            Me.txtProfissional.SetFocus
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
    
    item = Me.lstProfissionais.ListIndex: If item < 0 Then Exit Sub
    
    ID = Me.lstProfissionais.List(item, 0)
    
    If MsgBox("Voc� tem certeza que deseja [EXCLUIR] o item de ID: " & ID, vbQuestion + vbYesNo) = vbYes Then
        Me.lstProfissionais.RowSource = ""
        wsCadastros.ListObjects(Me.Tag).ListRows(ID).Delete
        Call PopulaListBox
        Me.btnLancamento.Enabled = True
        Me.btnExcluir.Enabled = True
        MsgBox "Registro exclu�do com sucesso.", vbInformation, Me.Caption
    End If
End Sub

Private Sub btnLancamento_Click()
    Dim oProfissional As cNewProfissional
    
    Set oProfissional = New cNewProfissional
        
    If Not ValidateEmptyControls(Me) Then
        Me.lstProfissionais.RowSource = ""
        With oProfissional
            .NomeProfissional = Me.txtProfissional.Value
            .cboProfissional = Me.txtCBO.Value
            .SaveOrChangeData
        End With
        
        Call PopulaListBox
        Call ClearFields(Me)
        
        MsgBox "Registro efetuado com sucesso.", vbInformation, Me.Caption
    End If
End Sub

Private Sub lstProfissionais_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    Dim item As Integer: item = Me.lstProfissionais.ListIndex
    
    With Me
        .btnLancamento.Enabled = False
        .btnExcluir.Enabled = False
        .txtProfissional.Value = .lstProfissionais.List(item, 1)
        .txtCBO.Value = .lstProfissionais.List(item, 2)
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
        .lstProfissionais.ColumnHeads = True
        .lstProfissionais.ColumnCount = rng.Columns.Count
        .lstProfissionais.RowSource = rng.Address(external:=1)
        .lstProfissionais.SetFocus
    End With
End Sub
