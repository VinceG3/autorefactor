CMS.Components.PlaylistEdit = React.createClass({
  displayName: 'PlaylistEdit',
  mixins: [Reflux.ListenerMixin],

  propTypes: {
    id: React.PropTypes.string,
    pageId: React.PropTypes.string,
    siteId: React.PropTypes.string
  },

  render: function() {
    var inputStyle = {height: '45px', width: '93%', marginRight: '10px'};
    var requiredInputStyle = {height: '45px', display: 'inline', width: '93%', marginRight: '10px'};
    var watchMoreStyle = {height: '45px', width: '60px', display: 'inline', marginRight: '10px'};

    var playlist = this.state.playlist;

    var gridTitle = 'Select Default Layout';
    if (playlist && playlist.gridLayout) {
      gridTitle = playlist.gridLayout === 'triangle' ? playlist.gridLayout : playlist.gridLayout + 'up';
    }

    var headerTypeTitle = 'Select Header Type';
    if (this.state.header && this.state.header.headerType && this.state.header.headerType) {
      headerTypeTitle = this.state.header.headerType + ' - ' + this.state.header.length + ' - ' + this.state.header.color;
    }

    var mobileImagePreview = this.getMobileImagePreview();
    var title = this.getTitle();
    // var intro = this.getIntro();
    var items = this.getItems();
    var headerItems = this.getHeaderItems();
    var labelValue = this.getLabelValue();
    var dotStyle = this.dotStyle;

    return (
      <div className='edit-playlist'>
        <div className='col-xs-12'>
          {this.getBreadcrumb()}
          <div className='col-xs-12'>
            <h1 className='col-xs-12 col-sm-6' id='titleHeader'> {title} </h1>
            <div className='col-xs-12 col-sm-4 pull-right'>
              <button className='btn btn-success btn-lg' onClick={this.handleSavePlaylist} style={{padding: '14px 16px'}}> Save </button>
              <CMS.Components.PreviewButton
                clickHandler={this.handlePreview}
                id={'preview_playlist' + playlist.id}
                isDisplayed={this.displayPreview}
                style={{marginLeft: '10px'}}
                text='Preview Playlist' />
            </div>
          </div>
          <div className='col-xs-12'> <hr style={{margin: '20px'}}/> </div>
        </div>

        <div className='col-xs-12' >
          {/* header type */}
          <div className='form-group col-xs-12'>
            <label className='col-xs-12 control-label' htmlFor='headerButton' style={this.labelStyle}>
              <span className={'pull-left status-icon-green'} id='headerStatus' style={dotStyle}></span>
              Header Type
            </label>
            <div className='dropdown col-xs-12 col-md-6'>
              <button aria-expanded='true' aria-haspopup='true' className='btn btn-default dropdown-button dropdown-toggle capitalize'
                data-toggle='dropdown' id='headerButton' type='button' >
                <span id='header-type-title'>{headerTypeTitle}</span>
                <span className='caret'></span>
              </button>
              <ul aria-labelledby='dropdownMenu1' className='dropdown-menu'>
                {headerItems}
              </ul>
            </div>
          </div>
        </div>
        {/* AppleTV Headers */}
        <div className='col-xs-12'>
          {this.getAppletvHeadersEdit()}
        </div>
        {/* Info Container */}
        <div className='col-xs-12'>
          <h3 className='col-xs-12'>Info </h3>
          {/* mobile stream */}
          <div className='form-group col-xs-12'>
            <div className='col-xs-4 col-md-6' style={{marginTop: '10px'}}>
              <label>
                <input id='inputStream' name='inputStream' type='checkbox' value={false} />
                &nbsp;&nbsp;Include Playlist in Mobile Stream
              </label>
            </div>
          </div>
          {/* Commented Continuous play check box until re-enable */}
          {/* Play All */}
          {/*
            <div className='form-group col-xs-12'>
              <div className='col-xs-4 col-md-6' style={{marginTop: '10px'}}>
                <label>
                  <input id='inputPlayAll' name='inputPlayAll' type='checkbox' value={false} />
                  &nbsp;&nbsp;Enable Play All
                </label>
              </div>
            </div>
          */}
          {/* vertical */}
          <CMS.Components.PlaylistEdit.VerticalEdit
            changeVertical={this.changeVertical}
            disableNeutral={this.disableNeutralHeader()}
            header={this.state.header}
            labelStyle={this.labelStyle}
            vertical={playlist.vertical} />
          {/* label */}
          <div className='form-group col-xs-12'>
            <label className='col-xs-12 control-label' htmlFor='inputLabel' style={this.labelStyle}>Label</label>
            <div className='col-xs-8 col-md-6'>
              <input className='form-control' defaultValue={labelValue} disabled id='inputLabel' placeholder='' style={inputStyle} type='text'></input>
            </div>
            <div className='col-xs-4 col-md-6' style={{marginTop: '10px'}}>
              <label>
                <input id='inputLabelIncluded' name='inputLabelIncluded' onChange={this.onCheckedChanged} type='checkbox' value={false} />
                &nbsp;&nbsp;Label Included
              </label>
            </div>
          </div>
          {/* intro */}
          <div className='form-group col-xs-12'>
            <label className='col-xs-12 control-label' htmlFor='inputIntro' style={this.labelStyle}>Intro</label>
            <div className='col-xs-12'>
              <input className='form-control' defaultValue={playlist.introduction} id='inputIntro' onChange={this.onChangeIntro}
                placeholder='First line' style={inputStyle} type='text'></input>
              {this.getCharCounter('intro')}
            </div>
          </div>
          {/* title */}
          <div className='form-group col-xs-12' id='groupTitleId'>
            <label className='col-xs-12 control-label' htmlFor='inputTitle' style={this.labelStyle}>
              <span className={'pull-left status-icon-green'} id='titleStatus' style={dotStyle}></span>
              Title
            </label>
            <div className='col-xs-12'>
              <input className='form-control' defaultValue={playlist.title} id='inputTitle' onChange={this.onChangeTitle}
                placeholder='Main title' style={requiredInputStyle} type='text'></input>
              {this.getCharCounter('title')}
            </div>
          </div>
          {/* subtext */}
          <div className='form-group col-xs-12' id='groupSubtextId'>
            <label className='col-xs-12 control-label' htmlFor='inputSubtext' style={this.labelStyle}>
              <span className={'pull-left status-icon-green'} id='subtextStatus' style={dotStyle}></span>
              Subtext
            </label>
            <div className='col-xs-12'>
              <input className='form-control' defaultValue={playlist.description} id='inputSubtext' onChange={this.onChangeDescription}
                placeholder='Description' style={requiredInputStyle} type='text'></input>
              {this.getCharCounter('subtext')}
            </div>
          </div>
          {/* slug */}
          <div className='col-xs-12'>
            <CMS.Components.SlugEditField id={playlist.id} slug={playlist.friendlyID} type={'Playlist'} urlRoot={Common.Constants.GBS_URL + '/playlists/'}/>
          </div>
          {/* image */}
          <div className='form-group col-xs-12 pbs'>
            <label className='col-xs-12 control-label' style={this.labelStyle}>
              <span className={'pull-left'} id='keyframeStatus' style={dotStyle}></span>
              Mobile Keyframe Image
            </label>
            <div className='col-xs-12'>
              <div className='col-xs-9 npl'>
                <input className='form-control' disabled name='mobile_key_frame_image_text' style={inputStyle} type='text' />
              </div>
              <span className='btn btn-default btn-file col-xs-3 fdr fac fjc'>
                <span className='form-file-label'>Upload File</span>
                <input id='file' name='mobile_key_frame_image' onChange={this.handleFile} required={false} type='file'/>
              </span>
            </div>
            <div className='row'>
              {mobileImagePreview}
            </div>
          </div>
        </div> {/* End info Container */}
        {/* Content Container */}
        <div className='col-xs-12'>
          <h3 className='col-xs-12'>Content </h3>
          {/* default layout */}
          <div className='form-group col-xs-12'>
            <label className='col-xs-12 control-label' htmlFor='defaultLayoutButton' style={this.labelStyle}>
              <span className={'pull-left status-icon-green'} id='layoutStatus' style={dotStyle}></span>
              Choose default layout
            </label>
            <div className='dropdown col-xs-12 col-md-6'>
              <button aria-expanded='true' aria-haspopup='true' className='btn btn-default dropdown-button dropdown-toggle capitalize' data-toggle='dropdown' id='gridLayoutButton' type='button' >
                <span id='grid-layout-title'>{gridTitle}</span>
                <span className='caret'></span>
              </button>
              <ul aria-labelledby='dropdownMenu1' className='dropdown-menu'>
                <li><a id={'1_up_Option'} role='button'>1up</a></li>
                <li><a id={'2_up_Option'} role='button'>2up</a></li>
                <li><a id={'3_up_Option'} role='button'>3up</a></li>
                <li><a id={'4_up_Option'} role='button'>4up</a></li>
                <li><a id={'triangle_Option'} role='button'>Triangle</a></li>
              </ul>
            </div>
          </div>
            {/* Watch More */}
          <div className='form-group col-xs-12' id='groupWatchMoreId'>
            <div className='col-xs-12' style={{marginTop: '20px'}}>
              <div className='col-xs-8 col-sm-5 col-md-4' style={{marginTop: '10px'}}>
                <label>
                  <span className={'pull-left status-icon-green'} id='watchMoreStatus' style={dotStyle}></span>
                  Show “Watch More” after this many videos:
                </label>
              </div>
              <input className='form-control' defaultValue={playlist.maxGridItems} id='inputWatchMore' onChange={this.onWatchMoreChanged} placeholder='#' style={watchMoreStyle} type='number'></input>
            </div>
            {/* Stories */}
            <CMS.Components.PlaylistEditItems items={items}
              onItemEditSelected={this.handleItemEditSelected}
              onItemsUpdated={this.handleItemsUpdated}/>
            {/* Sponsorships */}
            <CMS.Components.SponsorshipEdit checked={playlist.sponsored} extraMobileFieldsNeeded={true} initialSponsorship={playlist.sponsorship} onSponsorshipChanged={this.handleSponsorshipChanged} />
          </div>
        </div>
        <div className='col-xs-12 col-sm-12 col-md-12 ptl' style={{display: 'inline-block'}} >
          <button className='btn btn-success btn-lg btn-save-bottom' onClick={this.handleSavePlaylist} > Save </button>
          {this.getDeleteBtn()}
          <button className='btn btn-default btn-lg btn-cancel' onClick={this.handleCancel} > Cancel </button>
        </div>
        <div className='col-xs-12' style={{marginBottom:'50px'}}></div>
      </div>
    );
  }
});
